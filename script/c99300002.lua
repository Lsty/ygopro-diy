--秘封·伊奘诺物质
function c99300002.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c99300002.discon3)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c99300002.discon2)
	e2:SetValue(TYPE_TRAP)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c99300002.discon1)
	e3:SetCost(c99300002.cost)
	e3:SetTarget(c99300002.target)
	e3:SetOperation(c99300002.operation)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c99300002.discon2)
	e4:SetCost(c99300002.cost)
	e4:SetTarget(c99300002.target1)
	e4:SetOperation(c99300002.activate1)
	c:RegisterEffect(e4)
end
function c99300002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99300002)==0 end
	Duel.RegisterFlagEffect(tp,99300002,RESET_PHASE+PHASE_END,0,1)
end
function c99300002.discon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND)
end
function c99300002.discon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and e:GetHandler():IsLocation(LOCATION_SZONE)
end
function c99300002.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsFacedown() and Duel.GetCurrentChain()==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c99300002.filter(c,e,tp)
	return c:IsSetCard(0x993) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c99300002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c99300002.filter(chkc) end
	if chk==0 then
		return Duel.IsExistingTarget(c99300002.filter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectTarget(tp,c99300002.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c99300002.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()~=1 then return end
	Duel.SSet(tp,g)
	Duel.ConfirmCards(1-tp,g)
end
function c99300002.filter1(c,e,tp)
	return c:IsSetCard(0x993) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99300002.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c99300002.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c99300002.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c99300002.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(TYPE_TRAP)
	e:GetHandler():RegisterEffect(e1)
end
function c99300002.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end