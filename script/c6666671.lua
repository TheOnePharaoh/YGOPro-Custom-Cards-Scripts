
--Nihlah, Shaderune Queen
function c6666671.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2)
    c:EnableReviveLimit()
    --banish deck & draw
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,6666671)
    e1:SetCost(c6666671.drcost)
    e1:SetTarget(c6666671.tdtg)
    e1:SetOperation(c6666671.drop)
    c:RegisterEffect(e1)
    --banish deck & shuffle
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,6666671)
    e2:SetCondition(c6666671.tdcon)
    e2:SetTarget(c6666671.tdtg)
    e2:SetOperation(c6666671.tdop)
    c:RegisterEffect(e2)
end
function c6666671.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c6666671.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(tp,3):IsExists(Card.IsAbleToRemove,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,0,0)
end
function c6666671.cfilter(c)
	return c:IsSetCard(0x900) and c:IsLocation(LOCATION_REMOVED)
end
function c6666671.drop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,3)
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    local og=Duel.GetOperatedGroup()
    local ct=og:FilterCount(c6666671.cfilter,nil)
    if ct>0 then
        Duel.BreakEffect()
        Duel.Draw(tp,ct,REASON_EFFECT)
    end
end
function c6666671.tdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp)
end
function c6666671.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,3)
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    local og=Duel.GetOperatedGroup()
    local ct=og:FilterCount(c6666671.cfilter,nil)
    local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
    if ct~=0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(6666671,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sdg=dg:Select(tp,1,ct,nil)
        Duel.SendtoDeck(sdg,nil,2,REASON_EFFECT)
    end
end
