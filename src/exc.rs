use hex::FromHexError;

#[derive(Debug)]
pub enum Error {
    IOError(std::io::Error),
    HexDecodeError(String),
    Message(String),
}

impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            Error::IOError(e) => write!(f, "IOError: {}", e),
            Error::Message(e) => write!(f, "Error: {}", e),
            Error::HexDecodeError(e) => write!(f, "HexDecodeError: {}", e),
        }
    }
}

impl std::error::Error for Error {}

impl From<std::io::Error> for Error {
    fn from(e: std::io::Error) -> Self {
        Error::IOError(e)
    }
}

impl From<FromHexError> for Error {
    fn from(e: FromHexError) -> Self {
        match e {
            FromHexError::OddLength => Error::HexDecodeError(format!("odd length")),
            FromHexError::InvalidHexCharacter { c, index } => {
                Error::HexDecodeError(format!("invalid hex character {} at {}", c, index))
            }
            FromHexError::InvalidStringLength => {
                Error::HexDecodeError(format!("invalid string length"))
            }
        }
    }
}
