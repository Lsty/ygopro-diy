--疯狂之月
function c999988999.initial_effect(c)
	c:SetUniqueOnField(1,0,999988999)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
    e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999988999.target)
	e1:SetOperation(c999988999.operation)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(79856792,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c999988999.tdcost)
	e2:SetTarget(c999988999.tdtg)
	e2:SetOperation(c999988999.tdop)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c999988999.eqlimit)
	c:RegisterEffect(e3)
end
function c999988999.eqlimit(e,c)
	return  c:IsCode(999988995) or c:IsCode(999989926) 
end
function c999988999.filter(c)
	return c:IsFaceup() and c:IsCode(999988995) or c:IsCode(999989926) 
end
function c999988999.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999988999.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999988999.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999988999.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999988999.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c999988999.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c999988999.cfilter(c,def)
	return (c:IsFacedown() or c:GetDefence()<=def) and not (c:IsSetCard(0x985) or c:IsSetCard(0x984)) and c:IsAbleToDeck()
end
function c999988999.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler():GetEquipTarget()
	local  def=c:GetDefence()
	if chk==0 then return Duel.IsExistingMatchingCard(c999988999.cfilter,tp,0,LOCATION_MZONE,1,nil,def) end
	local g=Duel.GetMatchingGroup(c999988999.cfilter,tp,0,LOCATION_MZONE,nil,def)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c999988999.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler():GetEquipTarget()
	local  def=c:GetDefence()
    if  not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c999988999.cfilter,tp,0,LOCATION_MZONE,nil,def)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end