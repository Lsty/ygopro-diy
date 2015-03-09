--王之军势 
function c999999969.initial_effect(c)  
    --Activate  
    local e1=Effect.CreateEffect(c)  
    e1:SetType(EFFECT_TYPE_ACTIVATE)  
    e1:SetCode(EVENT_FREE_CHAIN)  
    e1:SetCondition(c999999969.actcon)
	e1:SetOperation(c999999969.actop)
	c:RegisterEffect(e1)  
    --攻击力上升
    local e2=Effect.CreateEffect(c)  
    e2:SetType(EFFECT_TYPE_FIELD)  
    e2:SetCode(EFFECT_UPDATE_ATTACK)  
    e2:SetRange(LOCATION_SZONE) 
    e2:SetTargetRange(LOCATION_MZONE,0)  
    e2:SetValue(c999999969.val)  
    c:RegisterEffect(e2)  
	--防御上升
    local e3=Effect.CreateEffect(c)  
    e3:SetType(EFFECT_TYPE_FIELD)  
    e3:SetCode(EFFECT_UPDATE_DEFENCE)  
    e3:SetRange(LOCATION_SZONE) 
    e3:SetTargetRange(LOCATION_MZONE,0)  
    e3:SetValue(c999999969.val)  
    c:RegisterEffect(e3)  
	--攻击力下降
    local e6=Effect.CreateEffect(c)  
    e6:SetType(EFFECT_TYPE_FIELD)  
    e6:SetCode(EFFECT_UPDATE_ATTACK)  
    e6:SetRange(LOCATION_SZONE) 
    e6:SetTargetRange(0,LOCATION_MZONE)  
    e6:SetValue(c999999969.val2)  
    c:RegisterEffect(e6)  
	--守备力下降
	local e4=Effect.CreateEffect(c)  
    e4:SetType(EFFECT_TYPE_FIELD)  
    e4:SetCode(EFFECT_UPDATE_DEFENCE)  
    e4:SetRange(LOCATION_SZONE) 
    e4:SetTargetRange(0,LOCATION_MZONE)  
    e4:SetValue(c999999969.val2)  
    c:RegisterEffect(e4)  
	--oraora
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE) 
	e5:SetTargetRange(LOCATION_MZONE,0)  
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetTarget(c999999969.tg)
	e5:SetValue(1)
	c:RegisterEffect(e5)
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c999999969.descon)
	c:RegisterEffect(e6)
	--cannot set
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_MSET)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(0,1)
	e7:SetTarget(aux.TRUE)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e9)
	local e10=e7:Clone()
	e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e10:SetTarget(c999999969.sumlimit)
	c:RegisterEffect(e10)
end  
function c999999969.actfilter(c)
	return c:IsFaceup() and c:IsCode(999989933) 
end
function c999999969.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999999969.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c999999969.actop(e,tp,eg,ep,ev,re,r,rp)
     local ct=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)  
	  Duel.ChangePosition(ct,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true) 
end
function c999999969.val(e,c)  
    return Duel.GetMatchingGroupCount(nil,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*100  
end  
function c999999969.val2(e,c)  
    return Duel.GetMatchingGroupCount(nil,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*-100  
end   
function c999999969.tg(e,c)
	return c:IsFaceup() and  c:IsCode(999989933) 
end
function c999999969.desfilter2(c)
	return c:IsFaceup() and c:IsCode(999989933) 
end
function c999999969.descon(e)
	return not Duel.IsExistingMatchingCard(c999999969.desfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) 
end
function c999999969.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end