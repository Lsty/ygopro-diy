--宝具 炽天覆七圆环
function c999988997.initial_effect(c)
	c:SetUniqueOnField(1,0,999988997)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
    e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999988997.target)
	e1:SetOperation(c999988997.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999988997.eqlimit)
	c:RegisterEffect(e2)
	 --disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_SZONE+LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetTarget(c999988997.distg)
	c:RegisterEffect(e3)
	--disable effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c999988997.disop)
	c:RegisterEffect(e4)
end
function c999988997.eqlimit(e,c)
	return  c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999988997.filter(c)
	return c:IsFaceup() and  c:IsCode(999999971)  or  c:IsCode(999999987) 
end
function c999988997.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999988997.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999988997.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999988997.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999988997.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c999988997.distg(e,c)
	if  c:GetCardTargetCount()==0  then return false end
	return c:GetControler()~=e:GetHandler():GetControler() and c:GetCardTarget():IsExists(c999988997.disfilter,1,nil,e:GetHandlerPlayer())
end
function c999988997.disfilter(c,tp)
	return c:IsControler(tp)  and c:IsLocation(LOCATION_MZONE) 
end
function c999988997.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or ep==tp then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()==0 then return end
	if g:IsExists(c999988997.disfilter,1,nil,tp) then
		Duel.NegateEffect(ev)
	end
end