from diagrams import Cluster, Diagram
from diagrams.k8s.compute import Pod
from diagrams.k8s.network import Service
from diagrams.k8s.storage import PVC

with Diagram("Kubernetes Resources", show=False):
    with Cluster("Namespace"):
        with Cluster("Pods"):
            kafka_0 = Pod("kafka-test-cluster-kafka-0")
            kafka_1 = Pod("kafka-test-cluster-kafka-1")
            kafka_2 = Pod("kafka-test-cluster-kafka-2")
            kafka_exporter = Pod("kafka-test-cluster-kafka-exporter-b44f84df5-mz7ls")
            zookeeper_0 = Pod("kafka-test-cluster-zookeeper-0")
            zookeeper_1 = Pod("kafka-test-cluster-zookeeper-1")
            zookeeper_2 = Pod("kafka-test-cluster-zookeeper-2")

        with Cluster("Services"):
            kafka_0_svc = Service("kafka-test-cluster-kafka-0")
            kafka_1_svc = Service("kafka-test-cluster-kafka-1")
            kafka_2_svc = Service("kafka-test-cluster-kafka-2")
            kafka_external_bootstrap_svc = Service("kafka-test-cluster-kafka-external-bootstrap")

        with Cluster("PVCs"):
            kafka_0_pvc = PVC("data-kafka-test-cluster-kafka-0")
            kafka_1_pvc = PVC("data-kafka-test-cluster-kafka-1")
            kafka_2_pvc = PVC("data-kafka-test-cluster-kafka-2")
            zookeeper_0_pvc = PVC("data-kafka-test-cluster-zookeeper-0")
            zookeeper_1_pvc = PVC("data-kafka-test-cluster-zookeeper-1")
            zookeeper_2_pvc = PVC("data-kafka-test-cluster-zookeeper-2")

    kafka_0 - kafka_0_svc
    kafka_1 - kafka_1_svc
    kafka_2 - kafka_2_svc
    kafka_0 - kafka_0_pvc
    kafka_1 - kafka_1_pvc
    kafka_2 - kafka_2_pvc
    zookeeper_0 - zookeeper_0_pvc
    zookeeper_1 - zookeeper_1_pvc
    zookeeper_2 - zookeeper_2_pvc
