class JaroWinkler
  THRESHOLD = 0.7

  class << self
    # This method calculates the Jaro-Winkler similarity between two strings.
    # The Jaro-Winkler similarity is a measure of similarity between two strings.
    # It is a variant of the Jaro distance metric and mainly used in the area of record linkage (duplicate detection).
    # The higher the Jaro-Winkler similarity, the more similar the strings are.
    # The method returns a float between 0.0 and 1.0, where 1.0 means the strings are identical.
    def similarity_distance(s1, s2)
      a1 = s1.split( // )
      a2 = s2.split( // )

      if s1.size > s2.size
        (max,min) = a1,a2
      else
        (max,min) = a2,a1
      end

      range = calculate_range(max)
      indexes, flags, matches = find_matches(min, max, range)
      ms1, ms2 = get_matching_sequences(min, max, indexes, flags, matches)
      transpositions = count_transpositions(ms1, ms2)
      prefix = count_prefix(s1, s2, min)

      calculate_similarity(s1, s2, matches, transpositions, prefix, max)
    end

    def calculate_range(max)
      [ (max.size / 2 - 1), 0 ].max
    end

    def find_matches(min, max, range)
      indexes = Array.new( min.size, -1 )
      flags   = Array.new( max.size, false )
      matches = 0

      (0 ... min.size).each do |mi|
        c1 = min[mi]
        xi = [mi - range, 0].max
        xn = [mi + range + 1, max.size].min

        (xi ... xn).each do |i|
          if (not flags[i]) && ( c1 == max[i] )
            indexes[mi] = i
            flags[i] = true
            matches += 1
            break
          end
        end
      end

      [indexes, flags, matches]
    end

    def get_matching_sequences(min, max, indexes, flags, matches)
      ms1 = Array.new( matches, nil )
      ms2 = Array.new( matches, nil )

      si = 0
      (0 ... min.size).each do |i|
        if (indexes[i] != -1)
          ms1[si] = min[i]
          si += 1
        end
      end

      si = 0
      (0 ... max.size).each do |i|
        if flags[i]
          ms2[si] = max[i]
          si += 1
        end
      end

      [ms1, ms2]
    end

    def count_transpositions(ms1, ms2)
      transpositions = 0
      (0 ... ms1.size).each do |mi|
        if ms1[mi] != ms2[mi]
          transpositions += 1
        end
      end

      transpositions
    end

    def count_prefix(s1, s2, min)
      prefix = 0
      (0 ... min.size).each do |mi|
        if s1[mi] == s2[mi]
          prefix += 1
        else
          break
        end
      end

      prefix
    end

    def calculate_similarity(s1, s2, matches, transpositions, prefix, max)
      if 0 == matches
        0.0
      else
        m = matches.to_f
        t = (transpositions/ 2)
        j = ((m / s1.size) + (m / s2.size) + ((m - t) / m)) / 3.0;
        return j < THRESHOLD ? j : j + [0.1, 1.0 / max.size].min * prefix * (1 - j)
      end
    end
  end
end
