use clap::Parser;
use hex;
use unhex::exc::Error;
use std::io::{self, Read, IsTerminal};


#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
#[command(propagate_version = true)]
pub struct CommandLine {
    #[arg(help = "valid hexadecimal data string", long_help = "[optional when /dev/stdin pipes out value]")]
    pub input: Option<String>,
}
impl CommandLine {
    pub fn read(&self) -> Result<String, Error> {
        match &self.input {
            Some(input) => Ok(input.clone()),
            None => {
                let mut stdin = io::stdin();
                if stdin.is_terminal() {
                    Err(Error::Message(format!("no input was provided and stdin is not a terminal!")))
                } else {
                    let mut input = String::new();
                    stdin.read_to_string(&mut input)?;
                    Ok(input)
                }
            }
        }
    }
}

fn main() -> Result<(), Error>{
    let ops = CommandLine::parse();
    let decoded = hex::decode(ops.read()?)?;
    println!("{}", decoded.iter().map(|s| format!("{:x}", s)).collect::<Vec<String>>().join(" "));
    Ok(())
}
