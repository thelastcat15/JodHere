## Cubit Flow Architecture

### User Flow with Separated Cubits:

```
┌─────────────────────────────────────────────────────────────────┐
│                      BOOKING PAGE                               │
│  Uses: ParkingListCubit                                         │
│  ✓ Shows searchable list of all parking locations              │
│  ✓ Real-time search filtering                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ User clicks "เลือก" button
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                PARKING BOOKING PAGE                              │
│  Uses: ParkingDetailCubit + SlotCubit + BookingCubit           │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ ParkingDetailCubit                                       │  │
│  │ • Fetches parking details by ID                          │  │
│  │ • Loads zone information                                 │  │
│  │ • Auto-selects first zone on page load                   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                    │
│                              ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ SlotCubit                                                │  │
│  │ • Fetches available slots for selected zone              │  │
│  │ • Triggered when zone is selected                        │  │
│  │ • Displays grid of parking slots                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                    │
│                              ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ BookingCubit                                             │  │
│  │ • Creates booking when slot is selected                  │  │
│  │ • Manages booking lifecycle (check-in, check-out)        │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Navigation Implementation:

**BookingParkingListItem Widget** (handles the "เลือก" button click)
```dart
// When user clicks the select button:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<ParkingDetailCubit>()),
        BlocProvider.value(value: context.read<SlotCubit>()),
        BlocProvider.value(value: context.read<BookingCubit>()),
      ],
      child: ParkingBookingPage(
        parkingId: parkingId,
        title: title,
        rating: rating,
        price: price,
      ),
    ),
  ),
);
```

### Step-by-Step Process:

1. **BookingPage** → User sees parking list (ParkingListCubit)
   - `ParkingListCubit.getParkings()` called in initState
   - Displays all parkings with search capability

2. **User searches/filters** → Real-time filtering
   - ParkingListCubit state updates with loaded parkings
   - Search/filter logic applied locally in widget

3. **User clicks "เลือก" button** → Navigate to ParkingBookingPage
   - BookingParkingListItem passes three Cubits via MultiBlocProvider
   - ParkingDetailCubit, SlotCubit, BookingCubit all available

4. **ParkingBookingPage initializes** → Load parking details & slots
   - `ParkingDetailCubit.getParkingDetail(parkingId)` called
   - First zone auto-selected from loaded zones
   - `SlotCubit.getParkingSlots(parkingId, firstZoneId)` called automatically

5. **Zone selection** → Load different zone's slots
   - User selects different zone chip
   - `SlotCubit.getParkingSlots(parkingId, newZoneId)` called
   - Slot grid updates with new availability

6. **Slot selection** → Create booking
   - User taps a slot
   - `BookingCubit.createBooking(...)` called
   - Booking summary sheet displays

### Key Benefits of This Architecture:

✅ **Independent loading states** - No conflicts between parking detail and slot loading
✅ **Clean separation** - Each Cubit responsible for one domain
✅ **Easy navigation** - Cubits passed cleanly via MultiBlocProvider
✅ **Scalability** - Easy to add new features (e.g., history, favorites)
✅ **Testability** - Each Cubit can be tested independently
