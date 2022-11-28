public record RegisterRec(string email, string FirstName, string LastName, string password,
    string phone, bool hasWhatsapp);

public record LoginRec(string email, string password);

public record UpdateRec(string email, string FirstName, string LastName,
    string Phone, bool HasWhatsapp);
