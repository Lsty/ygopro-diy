--神天龙-雳龙
function c9991220.initial_effect(c)
	--Synchro
	c:EnableReviveLimit()
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsRace,RACE_WYRM),aux.NonTuner(Card.IsSetCard,0xfff))
	--DD Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991220,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9991220)
	e1:SetCondition(c9991220.spcon)
	e1:SetTarget(c9991220.sptg)
	e1:SetOperation(c9991220.spop)
	c:RegisterEffect(e1)
	--Fuck Card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991220,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x1c0)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9991220)
	e2:SetCost(c9991220.cost1)
	e2:SetTarget(c9991220.tg1)
	e2:SetOperation(c9991220.op1)
	c:RegisterEffect(e2)
	--Summon Limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c9991220.sumsuc)
	c:RegisterEffect(e3)
end
function c9991220.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9991220.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetSummonPlayer()==tp
end
function c9991220.spfilter(c,e,tp)
	return c:IsSetCard(0xfff) and c:IsCanBeSpecialSummoned(e,0x40000fff,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9991220.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9991220.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and eg:IsExists(c9991220.cfilter,1,nil,e,tp) and not eg:IsContains(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991220.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991220.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SpecialSummon(g,0x40000fff,tp,tp,false,false,POS_FACEUP)
	end
end
function c9991220.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9991220.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9991220.sumlimit(e,c,sump,sumtype,sumpos,targetp,sumtp)
	return c:IsSetCard(0xfff) and bit.band(c:GetOriginalType(),TYPE_SYNCHRO)>0
end
function c9991220.filter(c)
	return c:IsAbleToDeckAsCost() and c:IsRace(RACE_WYRM)
end
function c9991220.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991220.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9991220.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,g) else Duel.HintSelection(g) end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c9991220.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c9991220.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg and sg:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Destroy(rg,REASON_EFFECT)
	end
end
