import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Time "mo:base/Time";

actor Identik {
  public type UserId = Nat32;

  public type UserProfile = {
    fullName : Text;
    nationalID : Text;
    birthPlace : Text;
    birthDate : Text;
    gender : Text;
    religion : Text;
    maritalStatus : Text;
    occupation : Text;
    nationality : Text;
    verified : Bool;
  };

  private stable var next : UserId = 0;
  private stable var userProfiles : Trie.Trie<UserId, UserProfile> = Trie.empty();
  private stable var userIDs : Trie.Trie<Text, UserId> = Trie.empty();

  public func createUserProfile(profile : UserProfile) : async UserId {
    let userId = next;
    next += 1;

    let uniqueIDAddress = generateUniqueIDAddress(userId);
    userIDs := Trie.replace(userIDs, textKey(uniqueIDAddress), Text.equal, ?userId).0;

    userProfiles := Trie.replace(userProfiles, key(userId), Nat32.equal, ?profile).0;

    return userId;
  };

  public query func getUserProfile(userId : UserId) : async ?UserProfile {
    return Trie.find(userProfiles, key(userId), Nat32.equal);
  };

  public func updateUserProfile(userId : UserId, profile : UserProfile) : async Bool {
    let exists = Option.isSome(Trie.find(userProfiles, key(userId), Nat32.equal));
    if (exists) {
      userProfiles := Trie.replace(userProfiles, key(userId), Nat32.equal, ?profile).0;
    };
    return exists;
  };

  public func verifyUser(userId : UserId) : async Bool {
    let profileOpt = Trie.find(userProfiles, key(userId), Nat32.equal);
    switch (profileOpt) {
      case (?profile) {
        let updatedProfile = { profile with verified = true };
        userProfiles := Trie.replace(userProfiles, key(userId), Nat32.equal, ?updatedProfile).0;
        return true;
      };
      case null {
        return false;
      };
    };
  };

  public query func shareUserProfile(userId : UserId) : async ?UserProfile {
    return Trie.find(userProfiles, key(userId), Nat32.equal);
  };

  private func textKey(x : Text) : Trie.Key<Text> {
    return { hash = Text.hash(x); key = x };
  };

  private func key(x : UserId) : Trie.Key<UserId> {
    return { hash = x; key = x };
  };

  private func generateUniqueIDAddress(userId : UserId) : Text {
    return "0x" # Nat32.toText(userId) # "-" # Int.toText(Time.now());
  };
};