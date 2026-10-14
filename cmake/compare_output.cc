// Compare the output of a PSPLINE test program with its reference output.
//
//   compare_output <output> <reference> [rtol] [atol]
//
// Lines are compared one by one. White space is ignored (as with diff -w),
// the remaining text must match exactly and numbers must agree within
//
//   |a - b| <= atol + rtol * max(|a|, |b|)
//
// The reference outputs were produced with gfortran; other compilers can
// differ in the last printed digit, or at round-off level (~1e-16) where the
// exact result is zero.

#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

namespace {

struct Token {
  bool is_number;
  std::string text;
  double value;
};

bool starts_number(const std::string &s, std::size_t i) {
  auto digit = [&](std::size_t j) {
    return j < s.size() && std::isdigit(static_cast<unsigned char>(s[j]));
  };
  if (digit(i)) return true;
  if (s[i] == '.' && digit(i + 1)) return true;
  if ((s[i] == '-' || s[i] == '+') && (digit(i + 1) || (i + 1 < s.size() && s[i + 1] == '.' && digit(i + 2))))
    return true;
  return false;
}

std::vector<Token> tokenise(const std::string &line) {
  std::vector<Token> tokens;
  std::string text;
  std::size_t i = 0;
  while (i < line.size()) {
    if (std::isspace(static_cast<unsigned char>(line[i]))) {
      ++i;
    } else if (starts_number(line, i)) {
      const char *begin = line.c_str() + i;
      char *end = nullptr;
      double value = std::strtod(begin, &end);
      if (!text.empty()) {
        tokens.push_back({false, text, 0.0});
        text.clear();
      }
      const std::size_t length = static_cast<std::size_t>(end - begin);
      tokens.push_back({true, line.substr(i, length), value});
      i += length;
    } else {
      text += line[i++];
    }
  }
  if (!text.empty()) tokens.push_back({false, text, 0.0});
  return tokens;
}

bool read_lines(const char *file, std::vector<std::string> &lines) {
  std::ifstream in(file);
  if (!in) {
    std::cerr << "compare_output: cannot open " << file << "\n";
    return false;
  }
  std::string line;
  while (std::getline(in, line)) lines.push_back(line);
  return true;
}

}  // namespace

int main(int argc, char *argv[]) {
  if (argc < 3 || argc > 5) {
    std::cerr << "usage: compare_output <output> <reference> [rtol] [atol]\n";
    return 2;
  }
  const double rtol = argc > 3 ? std::atof(argv[3]) : 1.0e-5;
  const double atol = argc > 4 ? std::atof(argv[4]) : 1.0e-12;

  std::vector<std::string> output, reference;
  if (!read_lines(argv[1], output) || !read_lines(argv[2], reference)) return 2;

  int mismatches = 0;
  const std::size_t n = std::max(output.size(), reference.size());
  for (std::size_t l = 0; l < n; ++l) {
    const std::string out = l < output.size() ? output[l] : "<missing>";
    const std::string ref = l < reference.size() ? reference[l] : "<missing>";
    const std::vector<Token> a = tokenise(out), b = tokenise(ref);
    bool same = a.size() == b.size();
    for (std::size_t t = 0; same && t < a.size(); ++t) {
      if (a[t].is_number != b[t].is_number) {
        same = false;
      } else if (a[t].is_number) {
        const double scale = std::max(std::fabs(a[t].value), std::fabs(b[t].value));
        same = std::fabs(a[t].value - b[t].value) <= atol + rtol * scale;
      } else {
        same = a[t].text == b[t].text;
      }
    }
    if (!same) {
      if (++mismatches <= 20) {
        std::cout << "line " << l + 1 << ":\n"
                  << "  output:    " << out << "\n"
                  << "  reference: " << ref << "\n";
      }
    }
  }

  if (mismatches > 0) {
    std::cout << mismatches << " line(s) differ (rtol=" << rtol << ", atol=" << atol << ")\n";
    return 1;
  }
  return 0;
}
