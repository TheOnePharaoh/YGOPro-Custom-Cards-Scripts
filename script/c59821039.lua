--CXyz Idol Master of Antares Constellation Seira Otoshiro
function c59821039.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-200)
	c:RegisterEffect(e1)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c59821039.pencon)
	e2:SetTarget(c59821039.pentg)
	e2:SetOperation(c59821039.penop)
	c:RegisterEffect(e2)
	--Negate summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(59821039,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCountLimit(1,59821039)
	e3:SetCondition(c59821039.discon)
	e3:SetCost(c59821039.discost)
	e3:SetTarget(c59821039.distg)
	e3:SetOperation(c59821039.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(59821039,1))
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(59821039,2))
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
	--immune spell
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c59821039.imcon)
	e6:SetValue(c59821039.efilter)
	c:RegisterEffect(e6)
	--battle indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(c59821039.indes)
	c:RegisterEffect(e7)
	--cannot be battle target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e8:SetTarget(c59821039.batlimit)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--search
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(59821039,3))
	e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e9:SetCondition(c59821039.thcon)
	e9:SetCost(c59821039.thcost)
	e9:SetTarget(c59821039.thtg)
	e9:SetOperation(c59821039.thop)
	c:RegisterEffect(e9)
	--to pzone
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e10:SetCategory(CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_DESTROYED)
	e10:SetCondition(c59821039.con)
	e10:SetOperation(c59821039.op)
	c:RegisterEffect(e10)
	--atkup
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(c59821039.atkvalcon)
	e11:SetValue(c59821039.atkval)
	c:RegisterEffect(e11)
	--add setcode
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e12:SetCode(EFFECT_ADD_SETCODE)
	e12:SetValue(0x1073)
	c:RegisterEffect(e12)
end
function c59821039.penfilter4(c)
    return c:IsSetCard(0xa1a2)
end
function c59821039.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821039.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821039.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821039.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821039.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821039.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c59821039.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c59821039.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c59821039.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c59821039.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c59821039.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821039.indes(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c59821039.batlimit(e,c)
	return c:IsFaceup() and c~=e:GetHandler() and c:IsSetCard(0xa1a2)
end
function c59821039.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821039.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c59821039.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa1a2) and c:IsAbleToHand()
end
function c59821039.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821039.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c59821039.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c59821039.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c59821039.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821039.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821039.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821039.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821039.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821039.penfilter2,tp,LOCATION_SZONE,0,nil)
		if g1 then 
		    g1:Merge(g2)
		else 
		    g1=g2
		end
	end
	if g1 and Duel.Destroy(g1,REASON_EFFECT)~=0 then 
	        local c=e:GetHandler()	
	        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
function c59821039.overlayfilter(c)
	return c:IsCode(59821008) or c:IsHasEffect(59821167)
end
function c59821039.atkvalcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c59821039.overlayfilter,1,nil)
end
function c59821039.atkvalfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2)
end
function c59821039.atkval(e,c)
	return Duel.GetMatchingGroupCount(c59821039.atkvalfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end