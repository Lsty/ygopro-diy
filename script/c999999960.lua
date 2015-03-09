--暗黑雾都
function c999999960.initial_effect(c)  
    c:SetUniqueOnField(1,0,999999960)
	--Activate  
    local e1=Effect.CreateEffect(c)  
    e1:SetType(EFFECT_TYPE_ACTIVATE)  
    e1:SetCode(EVENT_FREE_CHAIN)  
    e1:SetCondition(c999999960.actcon)
    c:RegisterEffect(e1)  
	--Lock
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c999999960.limtg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c999999960.descon)
	c:RegisterEffect(e4)
	--leave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c999999960.sop)
	c:RegisterEffect(e5)
	--send to grave
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_START)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c999999960.sgtg)
	e6:SetOperation(c999999960.sgop)
	c:RegisterEffect(e6)
	--burn
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetCondition(c999999960.damcon)
	e7:SetTarget(c999999960.damtg)
	e7:SetOperation(c999999960.damop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c999999960.actfilter(c)
	return c:IsFaceup() and c:IsCode(999999961) 
end
function c999999960.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999999960.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c999999960.limtg(e,c)
	return  c:IsStatus(STATUS_SUMMON_TURN)
		and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL+SUMMON_TYPE_SPECIAL+SUMMON_TYPE_FLIP)~=0
end
function c999999960.descon(e)
	return not Duel.IsExistingMatchingCard(c999999960.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c999999960.sfilter(c)
	return c:IsCode(999999961) and  c:IsFaceup()  and c:GetOverlayCount()==0
end
function c999999960.sop(e,tp,eg,ep,ev,re,r,rp)
		local dg=Duel.GetMatchingGroup(c999999960.sfilter,tp,LOCATION_MZONE,0,nil,c)
		Duel.SendtoGrave(dg,REASON_EFFECT)
end
function c999999960.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d==nil then return end
	if d:IsCode(999999961) then 
	if chk==0 then return d:CheckRemoveOverlayCard(tp,1,REASON_COST)  end
end
	if a:IsCode(999999961) then
	if chk==0 then return a:CheckRemoveOverlayCard(tp,1,REASON_COST) end
end
end
function c999999960.sgop(e,tp,eg,ep,ev,re,r,rp)
	 local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d==nil then return end
	 if d:IsCode(999999961) then 
	 d:RemoveOverlayCard(tp,1,1,REASON_COST)
	 Duel.SendtoGrave(a,REASON_EFFECT)
end
     if a:IsCode(999999961) then
	  a:RemoveOverlayCard(tp,1,1,REASON_COST)
	 Duel.SendtoGrave(d,REASON_EFFECT)
end
end
function c999999960.dafilter(c)
	return c:IsFaceup() 
end
function c999999960.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c999999960.dafilter,1,nil)  and ep==1-tp
end
function c999999960.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c999999960.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
