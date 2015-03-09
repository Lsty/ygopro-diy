--WB
function c3033103.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c3033103.ovfilter,aux.Stringid(38495396,1),3,c3033103.xyzop)
	c:EnableReviveLimit()
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c3033103.tg)
	e2:SetValue(c3033103.atkval)
	c:RegisterEffect(e2)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1834107,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c3033103.reccon)
	e2:SetTarget(c3033103.rectg)
	e2:SetOperation(c3033103.recop)
	c:RegisterEffect(e2)
    --DAMAGE
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(73206827,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c3033103.ccon)
	e4:SetTarget(c3033103.ctg)
	e4:SetOperation(c3033103.cop)
	c:RegisterEffect(e4)
end
function c3033103.ovfilter(c)
	return c:IsFaceup() and c:IsCode(3033031) or c:IsCode(3033032)
end
function c3033103.tg(e,c)
	return c:IsType(TYPE_XYZ)
end
function c3033103.atkval(e,c)
	return Duel.GetOverlayCount(c:GetControler(),LOCATION_MZONE,1)*300
end
function c3033103.reccon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	local rc=eg:GetFirst()
	return rc:IsControler(tp) and rc:IsType(TYPE_XYZ) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,3033031)
end
function c3033103.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c3033103.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c3033103.ccon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsType(TYPE_XYZ) and rc:IsFaceup() and rc:IsControler(tp) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,3033032)
end
function c3033103.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst():GetBattleTarget()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c3033103.cop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
