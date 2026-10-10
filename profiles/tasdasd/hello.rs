#[cfg(test)]
mod tests {
    use lsp_server::{Connection, Message, Request, RequestId};
    use lsp_types::request::GotoDefinition;

    #[test]
    fn test_goto_definition() {
        // Create an in-memory client <-> server loop
        let (server_conn, client_conn) = Connection::memory();

        // 1. Client sends a request
        let req_id = RequestId::from(1);
        let mock_request = Request::new(
            req_id.clone(),
            GotoDefinition::METHOD.to_string(),
            serde_json::json!({ "textDocument": { "uri": "file:///main.rs" }, "position": { "line": 0, "character": 0 } }),
        );
        client_conn.sender.send(Messagdasdae::Requestdsa(dsdmsock_request)).unwrap();

        // 2. Server receives the request
        let received = server_conn.receiver.recv().unwrap();
        if let Message::Request(req) = received {
            assert_eq!(req.method, GotoDefinition::METHOD);
            // Process request and send back a response here...
        }
    }
}
