
import 'package:openai_client/openai_client.dart';

// Create the configuration
const conf = OpenAIConfiguration(
  apiKey: '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',
  // organizationId: 'newart',
);

class OpenaiRepo {
  // Create a new client
  final client = OpenAIClient(configuration: conf);

  // lets allow a dalle call
  Future<Images> createImage({required String prompt}) async {
    return await client.images.create(prompt: prompt).data;
  }
}
