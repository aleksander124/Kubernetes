# from kubernetes import client, config, watch
import os

# clusterFile=open("api-clusters.txt", "w")

# clusters = """
# 1. newSS
# 2. newPreProd
# 3. newProd
# """

settings = """
1. Requests CPU
2. Requests memory
3. Limit CPU
4. Limit memory
"""

# print(clusters)
# selected_cluster = input("Select cluster you want use: ")

print(settings)
selected_task = input("Select your value: ")
if(int(selected_task) > 4 or int(selected_task) < 1):
    print("Wrong number")
else:
    # print("warunek działa")
    match selected_task:
        case "1":
            value = "9"
            print(f"Choosen value is: {selected_task}")
            command = "kubectl get resourcequotas -A | awk '{print $"+ value +"}' | grep -o -P '(?<=/).*(?=,)' | awk  '{s+=$1} END {printf s}' "
            # print(command)
            stream = os.popen(command)
            output = stream.read
            print(output)
        case "2":
            value = "13"
            print(f"Choosen value is: {selected_task}")
            print("kubectl get resourcequotas -A | awk '{print $"+ value +"}' | grep -o -P '(?<=/).*(?=,)' | awk  '{s+=$1} END {printf s}' ")
        case "3":
            value = "17"
            print(f"Choosen value is: {selected_task}")
            print("kubectl get resourcequotas -A | awk '{print $"+ value +"}' | grep -o -P '(?<=/).*(?=,)' | awk  '{s+=$1} END {printf s}' ")
        case "4":
            value = "19"
            print(f"Choosen value is: {selected_task}")
            print("kubectl get resourcequotas -A | awk '{print $"+ value +"}' | grep -o -P '(?<=/).*(?=,)' | awk  '{s+=$1} END {printf s}' ")



    
    
