abstract class EditCarStates{}

class EditCarInitialState extends EditCarStates{}

class ChangeCarBrand extends EditCarStates {}

class ChangeCarBody extends EditCarStates {}

class ChangeTransmission extends EditCarStates{}

class ChangeGas extends EditCarStates{}

class ChangeOption extends EditCarStates{}

class SetLanguageState extends EditCarStates{}

class GetLanguageFromDatabaseState extends EditCarStates {}

class TokenState extends EditCarStates{}

class GetCarSuccessfully extends EditCarStates{}

class DeleteCarSuccessfully extends EditCarStates{}

class UpdateCarSuccessfully extends EditCarStates{}