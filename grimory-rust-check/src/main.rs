fn calculate(values: &[i32]) -> i32 {
    values.iter().sum()
}

fn main() {
    let values = [10, 20, 30, 40];

    let result = calculate(&values);

    println!("Result: {result}");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_sum_values() {
        assert_eq!(calculate(&[10, 20, 30]), 60);
    }
}
