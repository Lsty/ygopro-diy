--ÍÁÖøÉñ  Ð¹Ê¸ÚÁ·Ã×Ó
function c329412.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x301),4,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c329412.thcon)
	e1:SetTarget(c329412.thtg)
	e1:SetOperation(c329412.thop)
	c:RegisterEffect(e1)
    --remove material
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c329412.rmcon)
    e2:SetOperation(c329412.rmop)
    c:RegisterEffect(e2)	
	--atk/def
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(c329412.atkval)
    e3:SetCondition(c329412.thcon)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENCE)
    c:RegisterEffect(e4)
	--add material
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c329412.amcon)
    e5:SetTarget(c329412.amtg)
    e5:SetOperation(c329412.amop)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e6)
end
function c329412.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetOverlayCount()~=0
end
function c329412.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetOverlayCount()>0 then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
    end
end
function c329412.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()~=0
end
function c329412.thfilter(c)
	return c:IsSetCard(0x302)  and c:IsAbleToHand() 
end
function c329412.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c329412.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)   
end
function c329412.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c329412.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c329412.atkval(e,c)
    return Duel.GetOverlayCount(c:GetControler(),LOCATION_MZONE,1)*300
end
function c329412.cfilter(c)
    return c:IsFaceup() and c:IsAttackBelow(1500) and not c:IsType(TYPE_TOKEN)
end
function c329412.amcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c329412.cfilter,1,nil) 
	and not eg:IsContains(e:GetHandler()) 
	and e:GetHandler():GetOverlayCount()>0
	and rp~=tp
end
function c329412.amtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=eg:Filter(c329412.cfilter,nil)
    Duel.SetTargetCard(eg)
end
function c329412.amfilter(c,e)
    return c:IsFaceup() and c:IsAttackBelow(1500) and c:IsRelateToEffect(e)
end
function c329412.amop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=eg:Filter(c329412.amfilter,nil,e)
    if g:GetCount()>0 then
        Duel.Overlay(c,g)
    end
end
