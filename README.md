Railway system
==============

## Insight

Data set is small (hundreds of stations). In a normal city, there are at most some thousands urban rail stations. With current (2019) computing power, a regular computer can find routes from one source to any other destination station in less than 200ms.

So the approach that I choose is using Depth First Search, with backtracking and heuristic (not check a path which is surely not better than current best), to find possible routes (if any) from one source to another destination station. During the process, select the optimized routes based criteria: time travel, number of stations.

Class `RoutesFinder` located at `lib/railway/services/routes_finder.rb` is the hearth of this algorithm. Important methods are `visit`, `backtrack` and `prepare`.

## API

Command Line Interface (CLI).

### Input

* Source station name
* Destination station name
* Start time: format: `YYYY-MM-DDThh:mm`, example `2019-01-31T16:00`. Can add seconds.
* Data file path: optional, default `data/StationMap.csv`.

### Output

**Fastest route**. Can output least-station route also, but I would like to keep output clean, easy to read and understand.

### Usage

**Prerequisite**: please [install Ruby](https://www.ruby-lang.org/en/documentation/installation/) if you do not have Ruby installed on your machine.

Executable is `bin/railway`.

Print help, option descriptions:

```
$ bin/railway -h
Usage: bin/railway [options]
    -s, --source station             Source station
    -d, --destination station        Destination station
    -t, --time time                  Start time, format: "YYYY-MM-DDThh:mm", e.g. "2019-01-31T16:00"
    -f, --data-file file             Railway network data file path in CSV format, optional, default "data/StationMap.csv"
    -h, --help                       Prints this help
```

Output of some examples are listed in section [Examples](#examples).

### Write to file

Command accepts output file name to write result into. If not specified, result is printed to standard output.

For example:

```
$ bin/railway -s 'Jurong East' -d 'Marina Bay' -t 2100-01-01T10:00:00 > output.txt
```

Then

```
$ cat output.txt
```

to see result. Or use other tools to read/parse/pipe this output.

## Data structure

The relationship between `Line` and `Station` is n-to-n. We use `LineStation` class to handle this n-to-n relationship.

`Network` holds lines and stations.

`Route` represents a route from source to destination station.

See these data structures in the `lib/models` directory.

## Steps

1. Read input file to a graph data structure in memory: `Network`, `Line` and `Station`.
1. Find the source & destination stations in the graph, from their names.
1. Using algorithm described at [Insight](#insight), find the best route(s) based on some criteria (time travel, number of stations) from source to destination station. In the process, consider characteristics of each route. Do not check all possible routes.
1. Output best route(s) with detailed description. Or output error and descriptive message if needed.

## Code organization

Executable is located in `bin/`, which calls main class `Railway`.

Code is located in `lib/`.

* `railway.rb`: main class, which requires other classes.
* `models/` to store data structures.
* `services/` to handle the logics, and route finding.

Tests are located in `spec/`.

* `integration/` for integration tests.
* Others are unit tests, structure is similar to `lib/`.

## Test

If you improve the code or add new functionalities, should use existing tests to make sure your changes do not break any existing thing. Remember to add/update tests for your new changes, too.

We use `rspec` for tests.

Install rspec

```
$ gem install rspec
```

 Run tests

```
$ rspec
..............................................................................................

Finished in 0.75249 seconds (files took 0.443 seconds to load)
94 examples, 0 failures
```

## Troubleshooting

If you see this error: `permission denied: bin/railway`, please run `chmod +x bin/railway` and try again.

## Improvements

* The code is designed for reading data file only once, then call different queries multiple times without reading and parsing data again. Can improve API to accept a list of queries and output result to stdout/file.
* Wait for rail line to operate (if it is not operating in night hours), if waiting time is less than taking other routes.
* Add new criteria: number of transfers.

## Contribute

Fork this repo and submit a Merge Request. All suggestions are welcomed.

## Other

The name of the executable is `railway`. To differentiate from `rails`, a famous web framework.

## Examples

In the examples below, I will set start time to `2100` to ensure that all stations are opened. Just for some special cases, this time will be setted to other values.

Here are outputs of some cases:

### Errors or route not found

#### Invalid input

```
$ bin/railway -s '  ' -d '' -t 2019 -f ''
Source station is required.
Destination station is required.
Start time is missing or invalid.
Data file path is invalid or not an existing file.
```

#### Identical source and destination stations

```
$ bin/railway -s 'Raffles Place' -d 'Raffles Place   ' -t 2100-01-01T10:00:00
Source and destination stations must be different.
```

#### Source and destination stations do not exist in data file

```
$ bin/railway -s 'Punggolll' -d 'Bisha' -t 2100-01-01T10:00:00 -f data/StationMap.csv
Source station does not exist: Punggolll
Destination station does not exist: Bisha
```

#### Source station is not opened at start time

```
$ bin/railway -s 'Sixth Avenue' -d 'Lavender' -t 2015-01-12T10:00:00
Source station is not opened at start time: Sixth Avenue
```

#### Source and destination stations are not connected

```
$ bin/railway -s 'Jurong East' -d 'Tanjong Rhu' -t 2100-01-01T10:00:00 -f spec/data/part.csv
There is no available route from Jurong East to Tanjong Rhu starting at 2100 January 01, 10:00:00
Reasons maybe:
- Source and destination stations are not connected.
- Destination station is not opened at sufficient time?
```

### Routes are found

#### Source and destination stations are next to each other

```
$ bin/railway -s 'Khatib' -d 'Yio Chu Kang' -t 2100-01-01T10:00:00
Fastest route to travel from Khatib to Yio Chu Kang:

Time travel: 0 hour 10 minutes
Start:       Friday, 2100 January 01, 10:00:00AM
Arrive:      Friday, 2100 January 01, 10:10:00AM
Stations:    1
Transfers:   0

On line NS, travel from Khatib to Yio Chu Kang, 1 stop

  Stations  Name              Arrive Time Transfer
Source = 0  Khatib        10:00:00AM
         1  Yio Chu Kang  10:10:00AM   10

Notes: times are in minutes
```

#### Travel on the same line

```
$ bin/railway -s 'Punggol' -d 'Chinatown' -t 2100-01-01T10:00:00
Fastest route to travel from Punggol to Chinatown:

Time travel: 2 hours 10 minutes
Start:       Friday, 2100 January 01, 10:00:00AM
Arrive:      Friday, 2100 January 01, 12:10:00PM
Stations:    13
Transfers:   0

On line NE, travel from Punggol to Chinatown, 13 stops

  Stations  Name              Arrive Time Transfer
Source = 0  Punggol       10:00:00AM
         1  Sengkang      10:10:00AM   10
         2  Buangkok      10:20:00AM   10
         3  Hougang       10:30:00AM   10
         4  Kovan         10:40:00AM   10
         5  Serangoon     10:50:00AM   10
         6  Woodleigh     11:00:00AM   10
         7  Potong Pasir  11:10:00AM   10
         8  Boon Keng     11:20:00AM   10
         9  Farrer Park   11:30:00AM   10
        10  Little India  11:40:00AM   10
        11  Dhoby Ghaut   11:50:00AM   10
        12  Clarke Quay   12:00:00PM   10
        13  Chinatown     12:10:00PM   10

Notes: times are in minutes
```

#### Need 1 transfer

```
$ bin/railway -s 'Punggol' -d 'Bugis' -t 2100-01-01T10:00:00
Fastest route to travel from Punggol to Bugis:

Time travel: 2 hours 6 minutes
Start:       Friday, 2100 January 01, 10:00:00AM
Arrive:      Friday, 2100 January 01, 12:06:00PM
Stations:    12
Transfers:   1

On line NE, travel from Punggol to Little India, 10 stops
Transfer from line NE to line DT at Little India
On line DT, travel from Little India to Bugis, 2 stops

  Stations  Name              Arrive Time Transfer
Source = 0  Punggol       10:00:00AM
         1  Sengkang      10:10:00AM   10
         2  Buangkok      10:20:00AM   10
         3  Hougang       10:30:00AM   10
         4  Kovan         10:40:00AM   10
         5  Serangoon     10:50:00AM   10
         6  Woodleigh     11:00:00AM   10
         7  Potong Pasir  11:10:00AM   10
         8  Boon Keng     11:20:00AM   10
         9  Farrer Park   11:30:00AM   10
        10  Little India  11:40:00AM   10       10
        11  Rochor        11:58:00AM    8
        12  Bugis         12:06:00PM    8

Notes: times are in minutes
```

#### Need more than 1 transfer

```
$ bin/railway -s 'Punggol' -d 'Tampines West' -t 2100-01-01T10:00:00
Fastest route to travel from Punggol to Tampines West:

Time travel: 2 hours 20 minutes
Start:       Friday, 2100 January 01, 10:00:00AM
Arrive:      Friday, 2100 January 01, 12:20:00PM
Stations:    13
Transfers:   2

On line NE, travel from Punggol to Serangoon, 5 stops
Transfer from line NE to line CC at Serangoon
On line CC, travel from Serangoon to MacPherson, 3 stops
Transfer from line CC to line DT at MacPherson
On line DT, travel from MacPherson to Tampines West, 5 stops

  Stations  Name                 Arrive Time Transfer
Source = 0  Punggol          10:00:00AM
         1  Sengkang         10:10:00AM   10
         2  Buangkok         10:20:00AM   10
         3  Hougang          10:30:00AM   10
         4  Kovan            10:40:00AM   10
         5  Serangoon        10:50:00AM   10       10
         6  Bartley          11:10:00AM   10
         7  Tai Seng         11:20:00AM   10
         8  MacPherson       11:30:00AM   10       10
         9  Ubi              11:48:00AM    8
        10  Kaki Bukit       11:56:00AM    8
        11  Bedok North      12:04:00PM    8
        12  Bedok Reservoir  12:12:00PM    8
        13  Tampines West    12:20:00PM    8

Notes: times are in minutes
```

#### Fastest route contains closed-at-night line

So chooses the next fastest route which does not use the closed line to transfer.

In this example, using DT line to transfer is the fastest choice. But DT line *closes at night time*. So this route uses NS line to transfer instead:

```
$ bin/railway -s 'Punggol' -d 'Bugis' -t 2100-01-01T23:00:00
Fastest route to travel from Punggol to Bugis:

Time travel: 2 hours 30 minutes
Start:       Friday, 2100 January 01, 11:00:00PM
Arrive:      Saturday, 2100 January 02, 01:30:00AM
Stations:    13
Transfers:   2

On line NE, travel from Punggol to Dhoby Ghaut, 11 stops
Transfer from line NE to line NS at Dhoby Ghaut
On line NS, travel from Dhoby Ghaut to City Hall, 1 stop
Transfer from line NS to line EW at City Hall
On line EW, travel from City Hall to Bugis, 1 stop

  Stations  Name              Arrive Time Transfer
Source = 0  Punggol       11:00:00PM
         1  Sengkang      11:10:00PM   10
         2  Buangkok      11:20:00PM   10
         3  Hougang       11:30:00PM   10
         4  Kovan         11:40:00PM   10
         5  Serangoon     11:50:00PM   10
         6  Woodleigh     12:00:00AM   10
         7  Potong Pasir  12:10:00AM   10
         8  Boon Keng     12:20:00AM   10
         9  Farrer Park   12:30:00AM   10
        10  Little India  12:40:00AM   10
        11  Dhoby Ghaut   12:50:00AM   10       10
        12  City Hall     01:10:00AM   10       10
        13  Bugis         01:30:00AM   10

Notes: times are in minutes
```

#### Fastest route contains not-finish-construction stations

So chooses the next fastest route which does not use the not-finish-construction stations.

In this example, using DT line to transfer is the fastest choice. But DT line *did not finish construction in 2012*. So this route uses NS line to transfer instead:

```
$ bin/railway -s 'Farrer Park' -d 'Novena' -t 2012-01-01T10:00:00
Fastest route to travel from Farrer Park to Novena:

Time travel: 1 hour 10 minutes
Start:       Sunday, 2012 January 01, 10:00:00AM
Arrive:      Sunday, 2012 January 01, 11:10:00AM
Stations:    6
Transfers:   1

On line NE, travel from Farrer Park to Dhoby Ghaut, 2 stops
Transfer from line NE to line NS at Dhoby Ghaut
On line NS, travel from Dhoby Ghaut to Novena, 4 stops

  Stations  Name              Arrive Time Transfer
Source = 0  Farrer Park   10:00:00AM
         1  Little India  10:10:00AM   10
         2  Dhoby Ghaut   10:20:00AM   10       10
         3  Somerset      10:40:00AM   10
         4  Orchard       10:50:00AM   10
         5  Newton        11:00:00AM   10
         6  Novena        11:10:00AM   10

Notes: times are in minutes
```

#### Source and destination is on the same line, but taking transfers is faster

In this example, both Jurong East and Marina Bay are on the NS line. But taking EW line and then transfer to TE line is a faster route than just staying in the NS line:

```
$ bin/railway -s 'Jurong East' -d 'Marina Bay' -t 2100-01-01T10:00:00
Fastest route to travel from Jurong East to Marina Bay:

Time travel: 1 hour 54 minutes
Start:       Friday, 2100 January 01, 10:00:00AM
Arrive:      Friday, 2100 January 01, 11:54:00AM
Stations:    11
Transfers:   1

On line EW, travel from Jurong East to Outram Park, 8 stops
Transfer from line EW to line TE at Outram Park
On line TE, travel from Outram Park to Marina Bay, 3 stops

  Stations  Name              Arrive Time Transfer
Source = 0  Jurong East   10:00:00AM
         1  Clementi      10:10:00AM   10
         2  Dover         10:20:00AM   10
         3  Buona Vista   10:30:00AM   10
         4  Commonwealth  10:40:00AM   10
         5  Queenstown    10:50:00AM   10
         6  Redhill       11:00:00AM   10
         7  Tiong Bahru   11:10:00AM   10
         8  Outram Park   11:20:00AM   10       10
         9  Maxwell       11:38:00AM    8
        10  Shenton Way   11:46:00AM    8
        11  Marina Bay    11:54:00AM    8

Notes: times are in minutes
```

(Note that the start time is in `2100`, so the TE line is built and in operation. In 2019, TE line is still under construction)

In this example, both Bukit Panjang and Expo are on the DT line. But taking 2 transfers (DT to CC and then CC back to DT) is faster than just staying in the DT line:

```
$ bin/railway -s 'Bukit Panjang' -d 'Expo' -t 2100-01-01T10:00:00
Fastest route to travel from Bukit Panjang to Expo:

Time travel: 3 hours 48 minutes
Start:       Friday, 2100 January 01, 10:00:00AM
Arrive:      Friday, 2100 January 01, 01:48:00PM
Stations:    24
Transfers:   2

On line DT, travel from Bukit Panjang to Botanic Gardens, 7 stops
Transfer from line DT to line CC at Botanic Gardens
On line CC, travel from Botanic Gardens to MacPherson, 8 stops
Transfer from line CC to line DT at MacPherson
On line DT, travel from MacPherson to Expo, 9 stops

  Stations  Name                  Arrive Time Transfer
Source = 0  Bukit Panjang     10:00:00AM
         1  Cashew            10:08:00AM    8
         2  Hillview          10:16:00AM    8
         3  Beauty World      10:24:00AM    8
         4  King Albert Park  10:32:00AM    8
         5  Sixth Avenue      10:40:00AM    8
         6  Tan Kah Kee       10:48:00AM    8
         7  Botanic Gardens   10:56:00AM    8       10
         8  Caldecott         11:16:00AM   10
         9  Marymount         11:26:00AM   10
        10  Bishan            11:36:00AM   10
        11  Lorong Chuan      11:46:00AM   10
        12  Serangoon         11:56:00AM   10
        13  Bartley           12:06:00PM   10
        14  Tai Seng          12:16:00PM   10
        15  MacPherson        12:26:00PM   10       10
        16  Ubi               12:44:00PM    8
        17  Kaki Bukit        12:52:00PM    8
        18  Bedok North       01:00:00PM    8
        19  Bedok Reservoir   01:08:00PM    8
        20  Tampines West     01:16:00PM    8
        21  Tampines          01:24:00PM    8
        22  Tampines East     01:32:00PM    8
        23  Upper Changi      01:40:00PM    8
        24  Expo              01:48:00PM    8

Notes: times are in minutes
```
