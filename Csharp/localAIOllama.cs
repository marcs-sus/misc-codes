using Microsoft.Extensions.AI;

const string endpointUri = "http://localhost:11434/";
const string AImodel = "deepseek-r1";

IChatClient chatClient =
    new OllamaChatClient(new Uri(endpointUri), AImodel);

// Start the conversation the AI model
List<ChatMessage> chatHistory = new();

while (true)
{
    // Get user prompt
    Console.WriteLine("Your prompt:");
    var userPrompt = Console.ReadLine();
    chatHistory.Add(new ChatMessage(ChatRole.User, userPrompt));

    // Stream AI response
    Console.WriteLine("AI Response:");
    var response = "";
    await foreach (var item in
        chatClient.CompleteStreamingAsync(chatHistory))
    {
        Console.Write(item.Text);
        response += item.Text;
    }
    chatHistory.Add(new ChatMessage(ChatRole.Assistant, response));
    Console.WriteLine();
}
