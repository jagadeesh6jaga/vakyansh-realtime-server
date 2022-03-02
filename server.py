from concurrent import futures
import grpc
from src.speech_recognition_service import SpeechRecognizer
from stub.speech_recognition_open_api_pb2_grpc import add_SpeechRecognizerServicer_to_server
from src.utilities import get_env_var

from src.lib.inference_lib import Wav2VecCtc


def run():
    workers = int(get_env_var('max_workers', 10))
    print('Using server workers:', workers)
    server = grpc.server(
        futures.ThreadPoolExecutor(max_workers=workers),
        # interceptors=(AuthInterceptor('Bearer mysecrettoken'),)
    )
    add_SpeechRecognizerServicer_to_server(SpeechRecognizer(), server)
    server.add_insecure_port('[::]:50052')
    print('***********************server going to start at port number 50052 ****************')
    server.start()
    print('********************** server started successfully ********************************')
    server.wait_for_termination()


if __name__ == '__main__':
    run()
