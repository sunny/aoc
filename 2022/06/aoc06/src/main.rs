fn main() {
  let input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb";

  let number = 14;
  let chars = input.chars().collect::<Vec<char>>();
  let mut substrings = chars.windows(number);
  let index = substrings.position(|substring|
    substring.iter().collect::<std::collections::HashSet<_>>().len() == number
  );

  match index {
    Some(index) => println!("{}", number + index),
    None => ()
  }
}
