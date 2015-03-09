--
function c999999896.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c999999896.ovfilter,aux.Stringid(91949988,0))
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c999999896.olcon)
	e1:SetTarget(c999999896.oltg)
	e1:SetOperation(c999999896.olop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c999999896.atkval)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCondition(c999999896.damcon)
	e3:SetCost(c999999896.damcost)
	e3:SetTarget(c999999896.damtg)
	e3:SetOperation(c999999896.damop)
	c:RegisterEffect(e3)
end
function c999999896.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c999999896.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local sl=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,sl,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,sl,sl,REASON_COST)
	e:SetLabel(sl)
end
function c999999896.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel()*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel()*500)
end
function c999999896.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c999999896.atkval(e,c)
	return c:GetOverlayCount()*300
end
function c999999896.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8d) and c:IsType(TYPE_XYZ)and c:IsRankBelow(3) 
end
function c999999896.filter(c)
	return c:IsSetCard(0x8d) and c:IsType(TYPE_MONSTER)
end
function c999999896.olcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c999999896.oltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(c999999896.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c999999896.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c999999896.olop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end