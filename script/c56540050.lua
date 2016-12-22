function c56540050.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(c56540050.condition)
    e1:SetTarget(c56540050.target)
    e1:SetOperation(c56540050.activate)
    c:RegisterEffect(e1)
   local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e4:SetCategory(CATEGORY_DISABLE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_GRAVE)
   e4:SetCondition(c56540050.condition)
    e4:SetCost(c56540050.ngcost)
    e4:SetTarget(c56540050.ngtg)
    e4:SetOperation(c56540050.ngop)
    c:RegisterEffect(e4)
end
function c56540050.cfilter(c)
    return c:IsPosition(POS_FACEUP)
end
function c56540050.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c56540050.condition(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp or not Duel.IsExistingMatchingCard(c56540050.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
    return Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c56540050.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c56540050.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c56540050.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c56540050.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c56540050.ngop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end