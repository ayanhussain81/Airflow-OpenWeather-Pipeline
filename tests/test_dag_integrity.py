from airflow.models import DagBag


def get_dag_bag():
    return DagBag(dag_folder="dags", include_examples=False)


def test_no_import_errors():
    dag_bag = get_dag_bag()
    assert not dag_bag.import_errors, f"DAG import errors: {dag_bag.import_errors}"


def test_at_least_one_dag_loaded():
    dag_bag = get_dag_bag()
    assert len(dag_bag.dags) > 0, "No DAGs were loaded from the dags/ folder"


def test_every_dag_has_tasks():
    dag_bag = get_dag_bag()
    for dag_id, dag in dag_bag.dags.items():
        assert len(dag.tasks) > 0, f"DAG {dag_id} has no tasks"
