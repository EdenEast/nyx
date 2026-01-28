use core::num;
use std::{
    collections::HashMap,
    fs::File,
    io::{BufRead, BufReader},
    path::{Path, PathBuf},
};

use jwalk::WalkDir;
use nom::{
    IResult, Parser,
    branch::alt,
    bytes::complete::{tag, take_until, take_while, take_while1},
    character::complete::{char, digit1, multispace0},
    combinator::{opt, recognize},
    sequence::tuple,
};

#[derive(Debug, PartialEq, Eq, Hash)]
enum Kind {
    PullRequest(u32),
    Issue(u32),
}

#[derive(Debug, PartialEq, Eq, Hash)]
struct Github {
    owner: String,
    repo: String,
    kind: Kind,
}

#[derive(Debug, PartialEq, Eq)]
struct Location {
    file: PathBuf,
    line: usize,
}

fn is_not_slash(c: char) -> bool {
    c != '/'
}

fn parse_prefix(input: &str) -> IResult<&str, &str> {
    let (input, _) = take_while(|c: char| !c.is_ascii_uppercase())(input)?; // take until a prefix
    let (input, prefix) = take_while1(|c: char| c.is_ascii_uppercase())(input)?;
    let (input, _) = opt(tuple((char('('), take_until(")"), char(')')))).parse(input)?;
    let (input, _) = char(':')(input)?;

    Ok((input, prefix))
}

fn parse_line(input: &str) -> IResult<&str, Github> {
    let (input, prefix) = parse_prefix(input)?;
    let (input, _) = multispace0(input)?;
    let (input, _) = tag("https://")(input)?;
    let (input, domain) = alt((tag("github.com/"), tag("gitlab.com/"))).parse(input)?;
    let (input, owner) = take_while1(is_not_slash)(input)?;
    let (input, _) = char('/')(input)?;
    let (input, repo) = take_while1(is_not_slash)(input)?;
    let (input, _) = char('/')(input)?;
    let (input, kind) = alt((tag("pull"), tag("issues"))).parse(input)?;
    let (input, _) = char('/')(input)?;
    let (input, number) = digit1(input)?;

    // match domain {
    //     "github.com/" => parse_github(input)?,
    //     "gitlab.com/" => parse_gitlab(input)?,
    //     _ => unreachable!(),
    // }

    let num = number.parse().unwrap();
    let kind = match kind {
        "pull" => Kind::PullRequest(num),
        "issues" => Kind::Issue(num),
        _ => unreachable!(),
    };

    Ok((
        input,
        Github {
            owner: owner.to_owned(),
            repo: repo.to_owned(),
            kind,
        },
    ))
}

fn check_content(path: &Path) -> Option<HashMap<Github, Vec<Location>>> {
    let mut results: HashMap<Github, Vec<Location>> = HashMap::new();

    let file = File::open(path).ok()?;
    let reader = BufReader::new(file);

    for (line_number, line) in reader.lines().enumerate() {
        if let Ok(content) = line {
            if let Ok((_, github)) = parse_line(&content) {
                println!("{}:{}: {}", path.display(), line_number + 1, content);
                let location = Location {
                    file: path.to_owned(),
                    line: line_number + 1,
                };
                let entry = results.entry(github).or_default();
                entry.push(location);
            }
        }
    }

    Some(results)
}

fn main() {
    let root = "/home/eden/c/nyx";
    let results = WalkDir::new(root)
        .skip_hidden(false)
        .into_iter()
        .filter_map(Result::ok)
        .filter_map(|entry| {
            if entry.file_type.is_file() {
                check_content(&entry.path())
            } else {
                None
            }
        })
        .flatten()
        .collect::<HashMap<_, _>>();

    dbg!(results);

    // for entry in WalkDir::new(root)
    //     .skip_hidden(false)
    //     .into_iter()
    // {
    //     if entry.file_type().is_file() {
    //         if let Ok(file) = File::open(entry.path()) {
    //             let reader = BufReader::new(file);
    //             for (line_num, line) in reader.lines().enumerate() {
    //                 if let Ok(content) = line {
    //                     if content.contains("TODO") {
    //                         println!("{}:{}: {}", entry.path().display(), line_num + 1, content);
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }
}

// Example usage/test
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_github() {
        let input = "FIXME: https://github.com/user/repo/pull/123";
        let (_, res) = parse_line(input).unwrap();
        assert_eq!(res.owner, "user");
        assert_eq!(res.repo, "repo");
        assert_eq!(res.kind, Kind::PullRequest(123));
    }

    #[test]
    fn test_github_with_comment() {
        let input = "  # FIXME: https://github.com/user/repo/pull/123";
        let (_, res) = parse_line(input).unwrap();
        assert_eq!(res.owner, "user");
        assert_eq!(res.repo, "repo");
        assert_eq!(res.kind, Kind::PullRequest(123));
    }

    // #[test]
    // fn test_gitlab() {
    //     let input = "TODO: https://gitlab.com/org/project/-/merge_requests/456";
    //     let (_, res) = url_line(input).unwrap();
    //     assert_eq!(res.prefix, "TODO");
    //     assert_eq!(res.platform, "gitlab");
    //     assert_eq!(res.user, "org");
    //     assert_eq!(res.repo, "project");
    //     assert_eq!(res.kind, "merge_requests");
    //     assert_eq!(res.number, "456");
    // }
}
