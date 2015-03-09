--狂乱 米斯蒂娅
function c31141555.initial_effect(c)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31141555,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c31141555.discon)
	e2:SetTarget(c31141555.distg)
	e2:SetOperation(c31141555.disop)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(c31141555.con)
	c:RegisterEffect(e5)
	--splimit
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ea:SetRange(LOCATION_GRAVE)
	ea:SetTargetRange(1,0)
	ea:SetTarget(c31141555.splimit)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_CANNOT_SUMMON)
	eb:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	eb:SetRange(LOCATION_GRAVE)
	eb:SetTargetRange(1,0)
	eb:SetTarget(c31141555.splimit)
	c:RegisterEffect(eb)
end
function c31141555.con(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	return e:GetHandler()==tc
end
function c31141555.splimit(e,c)
	return not c:IsRace(RACE_WINDBEAST)
end
function c31141555.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND)
end
function c31141555.filter(c)
	return c:IsSetCard(0x3d3) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c31141555.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31141555.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c31141555.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c31141555.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end