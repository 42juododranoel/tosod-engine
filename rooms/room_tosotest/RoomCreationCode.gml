var signature = global.tosotest.collection.signatures[global.tosotest.execution.signature_index]

global.tosotest.execution.object_id = instance_create_depth(0, 0, 16000, object_tosotest)

tosotest_execute_test(signature)
