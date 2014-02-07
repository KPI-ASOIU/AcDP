# =================================================
# Plurals rules for Ukrainian language
# =================================================
# use three keys for describing nouns in Ukrainian:
# => :one - for 1
# => :few - for 2, 3, 4 and all other numbers, 
#    which are ended with 2, 3, 4 except 12, 13, 14
# => :other - for all other numbers

{ uk: 
  { i18n: 
    { plural: 
      { keys: [:one, :few, :other],
        rule: lambda { |n| 
          if n == 1
            :one
          elsif [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) 
            :few 
          else
            :other 
          end
        } 
      } 
    } 
  } 
}