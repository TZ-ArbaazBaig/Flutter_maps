import 'package:currency_converter/demo_api/api_service.dart';
import 'package:currency_converter/demo_api/display_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Client {}

void main() {
  group("API Testing", () {
    late ApiService service;
    late MockHTTPClient mockHTTPClient;

    setUp(() {
      mockHTTPClient = MockHTTPClient();
      service = ApiService(client: mockHTTPClient);
    });

    test(
      "Valid API Response",
      () async {
        // Arrange
        when(
          () => mockHTTPClient.get(
            Uri.parse("https://jsonplaceholder.typicode.com/posts/1"),
          ),
        ).thenAnswer((_) async {
          return Response('''
            {
              "userId": 1,
              "id": 1,
              "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
              "body": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto"
            }
          ''', 200);
        });

        // Act
        final result = await service.displayModel();

        // Assert
        expect(result, isA<DisplayModel>());
        expect(result!.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit");
      },
    );

    test("API Response with 500 Status Code", () async {
      // Arrange
      when(
        () => mockHTTPClient.get(
          Uri.parse("https://jsonplaceholder.typicode.com/posts/1"),
        ),
      ).thenAnswer((_) async {
        return Response('{}', 500);
      });

      // Act & Assert
      final user=service.displayModel();
      expect(user, throwsException);
    });

    
    test("API Response with 404 Status Code", () async {
      // Arrange
      when(
        () => mockHTTPClient.get(
          Uri.parse("https://jsonplaceholder.typicode.com/posts/1"),
        ),
      ).thenAnswer((_) async {
        return Response('', 404);
      });

      // Act & Assert
      final user=service.displayModel();
      expect(user, throwsException);
    });
  });
}
