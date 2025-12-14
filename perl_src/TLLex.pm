# 
# vim: set et sw=4 sts=4 ai : 
use utf8;
use strict;
use warnings;
use Encode;

{
    package aux_Tokenizer_PathAndTreePat;
    use Carp;
    # 次の並びを連続してトークン化する  pathpat... ';' treepat...
    #
    # $self =
    # {
    #     orig => コード文字列,
    #     rest => 残りコード文字列,
    #     (
    #         mres_curr =>  # 最後のマッチの結果 マッチ部分
    #         mres_rest =>  # 最後のマッチの結果 残り
    #         mres_value =>  # 最後のマッチの結果 値
    #     )
    # }


    sub aux_bite_string
    {
        my $self = shift;
        my ($str) = @_;

        my $n = length $str;
        if (length($self->{rest}) < $n) { return 0; }

        my $head = substr($self->{rest}, 0, $n);
        if ( $head eq $str)
        {
            $self->{mres_curr} = $head;
            $self->{mres_rest} = substr($self->{rest}, $n);
            $self->{rest} = $self->{mres_rest};
            return 1;
        }
        else { return 0; }
    }
    sub aux_bite_pattern
    {
        my $self = shift;
        my ($pat) = @_;

        if ($self->{rest} =~ $pat)
        {
            my ($a,$b,$c) = ($`, $&, $');

            confess "Error in lex: '$pat' matches non head strings\n" if $a ne '';

            $self->{mres_curr} = $b;
            $self->{mres_rest} = $c;
            $self->{rest} = $c;
            return 1;
        }
        else { return 0; }
    }
    sub aux_bite_quoted_string_rest
    {
        my $self = shift;
        my ($endc, $qprefix, @qs) = @_;
        my ($curr, $value) = ('', '');
        while(1)
        {
            if (length($self->{rest}) == 0)
            { confess "Error in lex: run away quoted string(no [$endc])!\n"; }
            if ($self->aux_bite_string($endc))
            {
                $self->{mres_curr} = $curr;
                $self->{mres_value} = $value;
                return 1;
            }
            if ($self->aux_bite_string($qprefix))
            {
                $curr .= $self->{mres_curr};
                my $matched = 0;
                for my $q_pair(@qs)
                {
                    if ($self->aux_bite_string($q_pair->[0]))
                    {
                        $curr .= $self->{mres_curr};
                        $value .= $q_pair->[1];
                        $matched = 1;
                        last;
                    }
                }
                next if $matched;

                if (length($self->{rest}) == 0)
                { confess "Error in lex: run away quoted string (no char after [$qprefix])!\n"; }

                # not match: quote as is
                $curr .= substr $self->{rest}, 0, 1;
                $value .= substr $self->{rest}, 0, 1;
                $self->{rest} = substr $self->{rest}, 1;
                next;
            }
            # not match: 1char as is
            $curr .= substr $self->{rest}, 0, 1;
            $value .= substr $self->{rest}, 0, 1;
            $self->{rest} = substr $self->{rest}, 1;
        }
    }

    sub aux_bite_str_list
    {
        my $self = shift;
        my (@str_list) = @_;

        for my $str(@str_list)
        {
            my $result = $self->aux_bite_string($str);
            return $result if $result;
        }
        return 0;
    }

    sub aux_bite_char_list
    {
        my $self = shift;
        my ($str_list_join) = @_;
        my (@str_list) = split('', $str_list_join);

        return $self->aux_bite_str_list(@str_list);
    }
    #
    # $yylval = {type =>$type, val => $val, elem => []};

    sub reset
    {
        my $self = shift;
        $self->{rest} = $self->{orig};
        $self->read_next_token();
    }

    sub new
    {
        my $class = shift;
        my $self = {
            rest => $_[0],
            orig => $_[0],
            # pos_prev_b => 0,
            # pos_a => 0,
            # pos_b => 0,
            # # and, should maintain pre/post space position?
        };
        bless $self,$class;
        $self->read_next_token();
        return $self
    }

    sub read_next_token
    {
        my $self = shift;

        # 1. 空白や改行をスキップ
        if ($self->aux_bite_pattern(qr/\A[\s\n\r\x0d\x0a]+/))
        {
            # do something for skipping
        }
        # 1b. End of code
        if ($self->{rest} eq '')
        {
            $self->{following_token_id} = '(eot)';
            $self->{following_token_sv} = undef;
            return;
        }

        # 2. normal token

        # three or two three char
        #     hirano ver. : ## => & ,  (? => 無し
        #           new : (? 追加 , ##@ 追加
        if ( $self->aux_bite_str_list('##@', '##', '(?', ) )
        {
            # $yylval = {type =>$type, val => $val, elem => []};
            $self->{following_token_id} = $self->{mres_curr};
            $self->{following_token_sv} = {
                    id => $self->{mres_curr},
                    val => undef,
                    child => [],
                };
            return;
        }

        # one char
        #     hirano ver. : # => %
        #     hirano ver. : no +, ~, _
        if ( $self->aux_bite_char_list( '|>,(){}*#.?-$!' . '+~_;' ) )
        {
            # $yylval = {type =>$type, val => $val, elem => []};
            $self->{following_token_id} = $self->{mres_curr};
            $self->{following_token_sv} = {
                    id => $self->{mres_curr},
                    val => undef,
                    child => [],
                };
            return;
        }


        # 3. quoted literal
        #     new
        if ( $self->aux_bite_str_list(q{"}, q{'}, q{/} ) )
        {
            my $endc = $self->{mres_curr};

            my $res = $self->aux_bite_quoted_string_rest($endc, "\\", [$endc,$endc]);
            if (!$res) { confess "Error in lex: (quoted string '$endc'\n"; }

            my $id = 't_LITERAL';
            $id = 't_PATTERN_LITERAL' if $endc eq "/";

            # $yylval = {type =>$type, val => $val, elem => []};
            $self->{following_token_id} = $id;
            $self->{following_token_sv} = {
                    id => $id,
                    val => $self->{mres_value},
                    child => [],
                };

            if ($endc eq "/")
            {
                if (!$self->aux_bite_pattern( qr/\A[_A-Za-z]*/ ))
                { confess "Error: internal error (ac13f3ec_7f787326)\n"; }
                $self->{following_token_sv}->{option_str} = $self->{mres_curr};
            }
            return;
        }

        # 4. bare label literal
        #   hirano ver:  IDENTIFIER and ':'
        #       new: \w+\: => LABEL
        if ( $self->aux_bite_pattern( qr/\A[_A-Za-z0-9]+\:/ ) )
        {
            my $n = length($self->{mres_curr});
            my $val = substr($self->{mres_curr},0,$n-1);

            $self->{following_token_id} = 't_LABEL';
            $self->{following_token_sv} = {
                    id => 't_LABEL',
                    val => $val,
                    child => [],
                };
            return;
        }

        #
        # 5. bare literal
        #  hirano ver. : /^[0-9]+/ => NATURAL
        #  hirano ver. : qr/^[_A-Za-z][_A-Za-z0-9]*/ => IDENTIFIER
        #     new: /\A[_A-Za-z0-9]+/  LITERAL

        if ( $self->aux_bite_pattern( qr/\A[_A-Za-z0-9]+/ ) )
        {
            # $yylval = {type =>$type, val => $val, elem => []};
            $self->{following_token_id} = 't_LITERAL';
            $self->{following_token_sv} = {
                    id => 't_LITERAL',
                    val => $self->{mres_curr},
                    child => [],
                };
            return;
        }

        # Error: unexpected head string found
        #
        my $err_next_chars = length($self->{rest}) <= 10 ? $self->{rest}
            : substr($self->{rest}, 0, 10) . "...";
        confess "Error in lex: (unexpected chars) '" . $err_next_chars . "'\n";
    }
    package TokenizerByArray;
    sub new
    {
        my $class = shift;
        my @tokens = @_;
        my $self = {
            pos => -1,
            tokens => \@tokens,
            # pos_prev_b => 0,
            # pos_a => 0,
            # pos_b => 0,
            # # and, should maintain pre/post space position?
        };
        bless $self,$class;
        $self->read_next_token();
        return $self
    }
    sub reset
    {
        my $self = shift;
        $self->{pos} = -1;
        $self->read_next_token();
    }


    sub read_next_token{
        my $self = shift;

        if ($self->{pos} + 1 < @{ $self->{tokens}} )
        {
            $self->{pos}++;
            my $next_token = $self->{tokens}->[$self->{pos}];

            $self->{following_token_id} = $next_token->{id};
            $self->{following_token_sv} = $next_token;
            return;
        }
        else
        {
            $self->{pos} = @{ $self->{tokens} };
            $self->{following_token_id} = '(eot)';
            $self->{following_token_sv} = undef;
            return;
        }
    }
    
    package TokenizerSeparated;
    sub new
    {
        my $class = shift;
        my ($str) = @_;
        my $tok = aux_Tokenizer_PathAndTreePat->new($str);
        my @tokens_pathpat=();
        my @tokens_treepat=();

        # ? ? ? ; ? ? ? の列を読む ただし ; が出てこない時は全部後につける
        while(1)
        {
            # ';' が出てくるまで読む
            if ($tok->{following_token_id} eq ';')
            {
                @tokens_pathpat = @tokens_treepat;
                @tokens_treepat = ();
                $tok->read_next_token();
                last;
            }
            elsif ($tok->{following_token_id} eq '(eot)')
            {
                last;
            }
            else
            {
                push @tokens_treepat, $tok->{following_token_sv};
                $tok->read_next_token();
            }
        }

        while($tok->{following_token_id} ne '(eot)')
        {
            push @tokens_treepat, $tok->{following_token_sv};
            $tok->read_next_token();
        }


        my $self = {
            pathpat => TokenizerByArray->new(@tokens_pathpat),
            treepat => TokenizerByArray->new(@tokens_treepat),
        };
    }
}
1;
