--使徒少女－双子
function c187187024.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c187187024.spcon)
	e1:SetOperation(c187187024.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c187187024.con)
	e2:SetTarget(c187187024.target)
	e2:SetOperation(c187187024.operation)
	c:RegisterEffect(e2)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCountLimit(1,187187)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c187187024.cost)
	e2:SetTarget(c187187024.eqtg)
	e2:SetOperation(c187187024.eqop)
	c:RegisterEffect(e2)
end
function c187187024.cfilter(c)
	return c:IsSetCard(0xabb) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c187187024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187187024.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c187187024.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c187187024.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabb)
end
function c187187024.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c187187024.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c187187024.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c187187024.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c187187024.eqlimit)
	c:RegisterEffect(e1)
end
function c187187024.eqlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xabb)
end
function c187187024.spfilter(c,att)
	return c:IsSetCard(0x3abb) and not c:IsCode(187187024)
end
function c187187024.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c187187024.spfilter,tp,LOCATION_ONFIELD,0,2,nil,nil)
end
function c187187024.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c187187024.spfilter,tp,LOCATION_ONFIELD,0,1,2,nil,e,tp)
	Duel.Release(g,POS_FACEUP,nil,REASON_COST)
end
function c187187024.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c187187024.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,187187024)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.RegisterFlagEffect(tp,187187024,RESET_PHASE+PHASE_END,0,1)
end
function c187187024.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,187187998,0,0x109F,0,2100,4,RACE_DRAGON,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,187187998)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,187187999,0,0x109F,2450,0,4,RACE_DRAGON,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,187187999)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end