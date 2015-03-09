--传说之剑士 莫德雷德
function c999999989.initial_effect(c)
	aux.AddFusionProcFun2(c,c999999989.ffilter,c999999989.ffilter2,false)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c999999989.splimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c999999989.con)
	e2:SetTarget(c999999989.tg)
	e2:SetOperation(c999999989.op)
	c:RegisterEffect(e2)
	--[[--Attribute Dark
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40410110,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c999999989.attcon)
	e3:SetOperation(c999999989.attop)
	c:RegisterEffect(e3)--]]
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c999999989.disop)
	c:RegisterEffect(e6)
    --untargetable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e7:SetCondition(c999999989.utcon)
	e7:SetTarget(c999999989.uttg)
	e7:SetValue(c999999989.utval)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c999999989.utcon)
	e8:SetValue(c999999989.utval)
	c:RegisterEffect(e8)
	--背叛
	--[[local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetValue(1000)
	e9:SetCondition(c999999989.bpcon)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetCondition(c999999989.bpcon)
	e11:SetValue(c999999989.drpcon)
	e11:SetTarget(c999999989.drptg)
	e11:SetCountLimit(1)
	c:RegisterEffect(e11)--]]
	--special summon rule
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(27346636,1))
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetRange(LOCATION_EXTRA)
	e12:SetCondition(c999999989.sprcon)
	e12:SetOperation(c999999989.sprop)
	c:RegisterEffect(e12)
end
function c999999989.ffilter(c)
	return c:IsSetCard(0x991)
end
function c999999989.ffilter2(c)
	return  c:IsRace(RACE_WARRIOR)
end
function c999999989.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999999989.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c999999989.filter(c)
	local code=c:GetCode()
	return (code==999999979)
end
function c999999989.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999989.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999989.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999989.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(999997,5))) then
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc,c)
		else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
end
end
--[[function c999999989.attcon(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsCode,1,nil,999999979) and e:GetHandler():GetAttribute()~=ATTRIBUTE_DARK
end
function c999999989.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end--]]
function c999999989.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_SPELL) or rp==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then 
		Duel.NegateEffect(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end
function c999999989.utcon(e)
	return e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)
end
function c999999989.uttg(e,c)
	return e:GetHandler():GetEquipGroup():IsContains(c)
end
function c999999989.utval(e,re,rp)
	return rp~=e:GetHandlerPlayer() and  re:IsActiveType(TYPE_MONSTER)
end
--[[function c999999989.bpcon(e)
	return e:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
function c999999989.drpcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 
end
function c999999989.drptg(e,c)
	return  c:IsFaceup()
end--]]
function c999999989.spfilter1(c,tp)
	return c:IsSetCard(0x991)  and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(true)
	and Duel.IsExistingMatchingCard(c999999989.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c999999989.spfilter2(c)
	return c:IsRace(RACE_WARRIOR) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c999999989.spfilter3(c)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)  and c:IsAbleToGraveAsCost() 
end
function c999999989.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c999999989.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c999999989.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c999999989.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c999999989.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c999999989.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local g3=Duel.SelectMatchingCard(tp,c999999989.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end