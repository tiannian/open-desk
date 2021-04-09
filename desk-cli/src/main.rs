use coap::CoAPClient;
use serde::{Serialize, Deserialize};
use clap::Clap;

#[derive(Clap)]
#[clap(version = "1.0", author = "tiannian")]
pub struct Opts {
    #[clap(short = 'c', long = "command", default_value = "stop")]
    pub command: String,
    #[clap(short = 's', long = "speed")]
    pub speed: u32,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Command {
    pub command: String,
    pub speed: u32,
}

pub fn metor(command: &Command) {
    let url = "coap://192.168.1.239:5683/v1/f/server_handle";
    CoAPClient::post(url, serde_json::to_vec(command).unwrap()).unwrap();
}

fn main() {
    let opts: Opts = Opts::parse();
    let command = Command {
        command: opts.command,
        speed: opts.speed,
    };
    metor(&command);
}
