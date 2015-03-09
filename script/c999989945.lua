--王之理想乡 阿瓦隆
function c999989945.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c999989945.tg)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
    --destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c999989945.destg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
    --no damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(c999989945.damval)
	c:RegisterEffect(e5)
    --immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c999989945.imfilter)
	c:RegisterEffect(e6)
    --indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetValue(c999989945.valcon)
	e7:SetCountLimit(1)
	e7:SetTarget(c999989945.indtg)
	c:RegisterEffect(e7)
end
function c999989945.tg(e,c)
	return c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999989945.refilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemove()
end
function c999989945.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1  and dc:IsFaceup() and dc:IsControler(tp) and dc:IsLocation(LOCATION_MZONE)
		and (dc:IsSetCard(0x984) or dc:IsSetCard(0x985)) and
	Duel.IsExistingMatchingCard(c999989945.refilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(999997,3)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c999989945.refilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)return true
	else return false end
end
function c999989945.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end
function c999989945.imfilter(e,te)
	local c=te:GetHandler()
	return c:IsCode(999999977) or c:IsCode(999999963)
end
function c999989945.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c999989945.indtg(e,c)
    return  c:IsSetCard(0x991)
end