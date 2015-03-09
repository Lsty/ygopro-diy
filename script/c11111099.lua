--起源神 唯一的手
function c11111099.initial_effect(c)
    c:SetUniqueOnField(1,0,11111099)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,4)
	c:EnableReviveLimit()
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(11111099,0))
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11111099.xyzcon)
	e1:SetOperation(c11111099.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--unbreak
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c11111099.dscon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--double attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11111099,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c11111099.cost)
	e4:SetOperation(c11111099.operation)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11111099,2))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetTarget(c11111099.damtg)
	e5:SetOperation(c11111099.damop)
	c:RegisterEffect(e5)
end
function c11111099.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end	
function c11111099.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c11111099.ovfilter(c)
	return c:IsFaceup() and c:GetCode()==11111011
		
end
function c11111099.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return false end
	return Duel.IsExistingMatchingCard(c11111099.ovfilter,tp,LOCATION_MZONE,0,1,nil)
	    and Duel.IsExistingMatchingCard(c11111099.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function c11111099.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Group.CreateGroup()
	local tp=c:GetControler()
	Duel.DiscardHand(tp,c11111099.cfilter,1,1,REASON_COST+REASON_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c11111099.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local mg=tc:GetOverlayGroup()
	if mg:GetCount()~=0 then
	    sg:Merge(mg)
		Duel.Overlay(c,mg)
	end
	sg:Merge(Group.FromCards(tc))
	c:SetMaterial(sg)
	Duel.Overlay(c,Group.FromCards(tc))
end
function c11111099.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11111099.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
    end		
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c11111099.val)
	e2:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e2,tp)
end
function c11111099.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end
function c11111099.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
	local ct=e:GetHandler():GetOverlayCount()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c11111099.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=e:GetHandler():GetOverlayCount()
	if ct==0 then return end
	Duel.Damage(p,ct*500,REASON_EFFECT)
	Duel.BreakEffect()
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end