--秘封俱乐部 玛艾露贝莉·赫恩
function c99300009.initial_effect(c)
	c:SetUniqueOnField(1,0,99300009)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c99300009.cost)
	e1:SetTarget(c99300009.target)
	e1:SetOperation(c99300009.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c99300009.descon)
	c:RegisterEffect(e2)
end
function c99300009.descon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():GetCode()==99300010
end
function c99300009.cfilter(c,tp)
	return c:IsSetCard(0x993) and c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(c99300009.filter,tp,LOCATION_GRAVE,0,1,c)
end
function c99300009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99300009.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99300009.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99300009.filter(c)
	return c:IsSetCard(0x993) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c99300009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c99300009.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectTarget(tp,c99300009.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c99300009.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()~=1 then return end
	if Duel.SSet(tp,g)~=0 then
		Duel.ConfirmCards(1-tp,g)
	end
end