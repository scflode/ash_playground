# Ash Playground

This is a playground to evalulate and test the [Ash Framework](https://ash-hq.org).

To start your Phoenix server:

  * Run `./dev s`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Manual functionality

### Ash Archival

This is an extension enabling soft-deletes and recovery.

Once a ticket is `destroy`ed it will not show up anymore via the normal `read` actions. In order to recover you can run via iEx:

```
ticket = Playground.Support.RawTicket.archived!() |> hd()
Playground.Support.Ticket.unarchive!(ticket.id)
```

## Learn more

  * Phoenix Framework website: https://www.phoenixframework.org/
  * Ash Framework: https://ash-hq.org
