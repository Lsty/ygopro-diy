--变革者-乔治·华盛顿
function c9991400.initial_effect(c)
	--Search Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991400,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9991400.condition1)	
	e1:SetTarget(c9991400.target1)
	e1:SetOperation(c9991400.operation1)
	c:RegisterEffect(e1)
	--Special Summon From Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991400,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c9991400.cost2)
	e2:SetTarget(c9991400.target2)
	e2:SetOperation(c9991400.operation2)
	c:RegisterEffect(e2)
	--Tokushu Shoukan
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c9991400.spcon)
	e4:SetOperation(c9991400.spop)
	c:RegisterEffect(e4)
end
function c9991400.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c9991400.filter,2,nil)
end
function c9991400.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c9991400.filter,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c9991400.filter(c)
	return c:IsLevelAbove(4) and c:IsRace(RACE_WARRIOR)
end
function c9991400.filter1(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c9991400.filter2(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function c9991400.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c9991400.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9991400.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9991400.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9991400.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c9991400.filter1,tp,LOCATION_DECK,0,1,nil)
	and Duel.IsExistingMatchingCard(c9991400.filter2,tp,LOCATION_DECK,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c9991400.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c9991400.filter2,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2) Duel.SendtoHand(g1,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g1)
end
function c9991400.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsRace,1,nil,RACE_WARRIOR) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsRace,1,1,nil,RACE_WARRIOR)
	Duel.Release(g,REASON_COST)
end
function c9991400.filter3(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9991400.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991400.filter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9991400.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991400.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
