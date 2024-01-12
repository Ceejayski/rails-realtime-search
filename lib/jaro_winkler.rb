class JaroWinkler
  THRESHOLD = 0.7

  class << self
    # This method calculates the Jaro-Winkler similarity between two strings.
    # The Jaro-Winkler similarity is a measure of similarity between two strings.
    # It is a variant of the Jaro distance metric and mainly used in the area of record linkage (duplicate detection).
    # The higher the Jaro-Winkler similarity, the more similar the strings are.
    # The method returns a float between 0.0 and 1.0, where 1.0 means the strings are identical.
    def similarity_distance(s1, s2)
      a1 = s1.split(//)
      a2 = s2.split(//)
      max, min = s1.size > s2.size ? [a1, a2] : [a2, a1]

      range = [max.size / 2 - 1, 0].max
      indexes, flags, matches = find_matches(min, max, range)

      ms1 = indexes.filter_map { |i| i.nil? ? nil : min[i] }
      ms2 = flags.map.with_index { |flag, i| flag ? max[i] : nil }.compact

      transpositions = count_transpositions(ms1, ms2)
      prefix = count_prefix(min, max)

      calculate_similarity(s1.size, s2.size, matches, transpositions, prefix, max.size)
    end
    private
      # This method calculates the Jaro-Winkler similarity between two strings.
      # The Jaro-Winkler similarity is a measure of similarity between two strings.
      # It is a variant of the Jaro distance metric and mainly used in the area of record linkage (duplicate detection).
      # The higher the Jaro-Winkler similarity, the more similar the strings are.
      # The method returns a float between 0.0 and 1.0, where 1.0 means the strings are identical.
      def find_matches(min, max, range)
        indexes = Array.new(min.size, -1)
        flags = Array.new(max.size, false)
        matches = 0

        (0...min.size).each do |mi|
          c1 = min[mi]
          xi = [mi - range, 0].max
          xn = [mi + range + 1, max.size].min

          xi.upto(xn) do |i|
            next unless !flags[i] && (c1 == max[i])

            indexes[mi] = i
            flags[i] = true
            matches += 1
            break
          end
        end

        [indexes, flags, matches]
      end

      # This method counts the number of transpositions between two matched strings.
      # A transposition is when two characters that match in the two strings are in a different order.
      # The method returns the number of transpositions.
      def count_transpositions(ms1, ms2)
        ms1.zip(ms2).count { |m1, m2| m1 != m2 }
      end

      # This method counts the number of identical chars at the start of the min and max strings.
      # The method returns the count of identical starting characters.

      def count_prefix(min, max)
        min.take_while.with_index { |c, i| c == max[i] }.size
      end

      # This method calculates the Jaro-Winkler similarity score based on the size of the two strings,
      # the number of matches, the number of transpositions, the length of the common prefix, and the size of the larger string.
      # The method returns the Jaro-Winkler similarity score.
      def calculate_similarity(s1_size, s2_size, matches, transpositions, prefix, max_size)
        return 0.0 if matches.zero?

        m = matches.to_f
        t = transpositions / 2
        j = (m / s1_size + m / s2_size + (m - t) / m) / 3.0

        j < THRESHOLD ? j : j + [0.1, 1.0 / max_size].min * prefix * (1 - j)
      end
  end
end
