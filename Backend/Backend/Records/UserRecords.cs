public record RegisterRec(string email, string FirstName, string LastName, string password,
    string phone, bool hasWhatsapp);


public record LoginRec(string email, string password);

