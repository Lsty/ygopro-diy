--鲜血魔娘
function c999989936.initial_effect(c)  
    c:SetUniqueOnField(1,0,999989936)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999989936.target)
	e1:SetOperation(c999989936.operation)
	c:RegisterEffect(e1)
	--atk/def down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999998,11))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c999989936.atktg)
	e2:SetOperation(c999989936.atkop)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c999989936.eqlimit)
	c:RegisterEffect(e3)
end
function c999989936.eqlimit(e,c)
	return  c:IsCode(999989939)  
end
function c999989936.filter(c)
	return c:IsFaceup() and c:IsCode(999989939) 
end
function c999989936.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999989936.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999989936.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999989936.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999989936.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c999989936.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c999989936.atkop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
local c=e:GetHandler()
local oc=c:GetEquipTarget()
local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
local atk=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,nil)*-200
		local tc=g:GetFirst()
		local dg=Group.CreateGroup()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(atk)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENCE)
			tc:RegisterEffect(e2)
			if  (preatk~=0 and tc:GetAttack()==0) or (predef~=0 and tc:GetDefence()==0)    then dg:AddCard(tc) end
			tc=g:GetNext()	   
end
			if Duel.Destroy(dg,REASON_EFFECT)>0 then 
			local f=dg:GetFirst()
			while f do
			local og=f:GetOverlayGroup()
		    if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)   end
            if f:IsType(TYPE_TOKEN) then return end              
			Duel.Overlay(oc,f)
		    f=dg:GetNext()	 
end 
end
end
