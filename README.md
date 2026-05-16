This project introduces an intelligent, rule-based expert system designed to simulate medical diagnosis. The system acts as a smart assistant that takes symptoms as inputs, analyzes them through programmed medical logic to provide the diagnosis, and formulates the optimal treatments. 

System Requirements:
Compiler: SWI-Prolog desktop
Dependencies: standard lists library from SWI-Prolog (:- use_module(library(lists)).). No additional external packages are required


How to run the program:
Open your Prolog environment (SWI-Prolog on desktop)
Save the program file as diagnosis.pl in the same folder you are working in.
In the Prolog window, load the file, use the full file path where you saved the Prolog file.
In code, write (replace this path with your own):

In code write: ['C:/path/to/your/diagnosis.pl']. (your path)

After loading, start the diagnosis.

In code write: ?- start_diagnosis.

When the system asks you to choose a system, type one of these options and end with a dot:
In code write: skin.
or in code write: respiratory.
or in code write: digestive.

Answer the questions using:
In code write: yes.
In code write: no.

At the end the system will:
Show the likelihood (percentage) for each possible disease.
Print the final diagnosis.
Print suggested medications or treatments for this case.

Running search on treatment plans (BFS and A*):
For the cases burn and influenza, the system can run search algorithms on treatment plans as follows:

To use BFS for an influenza treatment plan:
In code, write: ?- bfs_treatment_search(influenza, Plan).

To use BFS for a burn treatment plan:
In code, write: ?- bfs_treatment_search(burn, Plan).

To use A* for an influenza treatment plan:
In code, write: ?- astar_treatment_search(influenza, Plan).

To use A* for a burn treatment plan:
In code write: ?- astar_treatment_search(burn, Plan).


If you want to run the diagnosis again start the program again:
In code, write: ?- start_diagnosis.


The uncertainty scenarios are tested by entering symptoms that do not clearly match one disease or by creating 
close scores between two possible diseases. the system does not force a fully certain diagnosis, it either selects the disease
with the highest score or gives an initial/simple treatment then asks the user to repeat the diagnosis
