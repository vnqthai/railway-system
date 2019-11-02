Design
======

## Insight

Data set is small (hundreds of stations). In a normal city, there are at most some thousands urban rail stations. With current (2019) computing power, a regular computer can find routes from one source to any other destanation station in less than 100ms.

So the approach that I choose is find possible routes (if any) from one source to another destination station. Then compare these routes by some criteria.

## API

Command Line Interface (CLI).

Input: source and destination station names.

Output: Route(s)

Command accepts input file name and can choose output file name. If not specify output file name, result will be printed to standard output.

### Usage

Print help, option descriptions

```
$ bin/railway -h
```


## Steps

1. Read input file to a graph data structure in memory
1. Find the source & destination stations in the graph, from their names
1. Find posible route(s) from source to destanation station. Use Depth First Search to check possible routes.
1. Calculate characteristics of each route (time travel, number of stations)

Handle special cases:

* There is no route.

## Data structure

The relationship between Line and Station is n-to-n. We use LineStation class to handle this n-to-n relationship.

## Code organisation

Dynamic, customizable configaration:

* Peak hours
* Time to travel between stations (different per lines)
* Time to transfer

### Data structures

* Station
* Graph
  * Stations
  * Connections
* Route
  * Time to travel
  * Stations count

## Test

Use `rspec`.

* Install rspec

```
$ gem install rspe
```

* Run tests

```
$ rspec
```

## Troubleshooting

If you see this error: `permission denied: bin/railsystem`, please run `chmod +x bin/railsystem` then try again.

## Futher improvements

* Wait for line to operate (if it is not operating in night hours), if waiting time is less than taking another route.

## Contribute

Fork this repo and submit a Merge Request.

## Other

The name of executable and class are `railway`. Which is different from `rails` - a famous web framework.
