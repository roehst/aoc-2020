Day 7.

Day 7 turned out to be quite a surprise for me. 

I started with Python. Parsing the inputs was kind of a mess because I tried using a lot of primitives and comprehensions. The code looks more or less clean right now but it took a few tries. Also I took some time to see that the problem was about graph searches. Problem 1 was then to count how many nodes are reachable from a the start node. I did that with the very typical queue/BFS + visited nodes set. Problem 2 was a bit trickier because we sum all the possible paths to the leaf nodes. Luckily the graph is a DAG.

But Problem 2 turned out to be much easier in Haskell! Reading in the input lines was easy with Parsec, and doing graph searches was _much_ easier with recursion and list comprehensions. I also modeled the edges as a `Rule String String Int` type, which helped me.

Day 8.

This was rather easy since I have some experience playing with interpreters. I just wrote a parser for the operations and an array-based machine to execute the code. It was not recursive on the stream of operations since I wanted jumps.
