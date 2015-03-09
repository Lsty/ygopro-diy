--传说之骑兵 伊斯坎达尔
function c999989933.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c999989933.spcon)
	e1:SetOperation(c999989933.spop)
	c:RegisterEffect(e1)
    --search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,999989933+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c999989933.tg)
	e2:SetOperation(c999989933.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	 --atk/def
    local e4=Effect.CreateEffect(c)  
    e4:SetType(EFFECT_TYPE_FIELD)  
    e4:SetCode(EFFECT_UPDATE_ATTACK)  
    e4:SetRange(LOCATION_MZONE) 
    e4:SetTargetRange(LOCATION_MZONE,0)  
    e4:SetValue(c999989933.val)  
    c:RegisterEffect(e4)  
end
function c999989933.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,2,c)
end
function c999989933.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,2,2,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c999989933.sfilter(c)
	local code=c:GetCode()
	return (code==999999969 or code==999999970) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999989933.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989933.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999989933.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999989933.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c999989933.val(e,c)  
    return Duel.GetMatchingGroupCount(nil,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*100  
end  