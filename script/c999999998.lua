--传说之王 征服王 伊斯坎达尔
function c999999998.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c999999998.xyzfilter),8,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c999999998.stg)
	e1:SetOperation(c999999998.sop)
	c:RegisterEffect(e1)
    --cannot disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
    --summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c999999998.sumcon)
	e3:SetOperation(c999999998.sumsuc)
	c:RegisterEffect(e3)
    --special xyz_summon 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999998,12))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c999999998.spcon)
	e4:SetOperation(c999999998.spop)
	c:RegisterEffect(e4)
	--add code
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_ADD_CODE)
	e5:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e5:SetValue(999989933)
	c:RegisterEffect(e5)
end
function c999999998.xyzfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999999998.eqfilter(c)
	return c:IsCode(999999970) 
end
function c999999998.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return   chkc:IsLocation(LOCATION_GRAVE+LOCATION_DECK) and chkc:IsControler(tp) and c999999998.eqfilter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and 
	Duel.IsExistingTarget(c999999998.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e:GetHandler())  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectTarget(tp,c999999998.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999998.sfilter(c)
	return c:IsCode(999999969) and c:IsAbleToHand()
end
function c999999998.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFirstTarget()
	 if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if g1:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Equip(tp,g1,c)
	end
	if Duel.IsExistingMatchingCard(c999999998.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and  Duel.SelectYesNo(tp,aux.Stringid(999999,2)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c999999998.sfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g2 then  
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
end
function c999999998.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c999999998.filter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c999999998.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999999998.filter,tp,0,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c999999998.aclimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c999999998.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c999999998.ovfilter1(c)
	return c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999999998.ovfilter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c999999998.spcon(e,c)
	if  Duel.IsExistingMatchingCard(c999999998.ovfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil) and
	Duel.IsExistingMatchingCard(c999999998.ovfilter2,e:GetHandlerPlayer(),LOCATION_SZONE+LOCATION_HAND,0,2,nil) then return true
	else return false end
end
function c999999998.spop(e,tp,eg,ep,ev,re,r,rp,c)	
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c999999998.ovfilter2,e:GetHandlerPlayer(),LOCATION_SZONE+LOCATION_HAND,0,2,2,nil)
	local g2=Duel.SelectMatchingCard(tp,c999999998.ovfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if g1:GetCount()==2  and g2:GetCount()==2 then
	Duel.SendtoGrave(g1,REASON_COST)
    Duel.Overlay(c,g2)
end
end