--The Idol Master of Miraclous Angel Averte
function c59821121.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
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
	e2:SetCondition(c59821121.pencon)
	e2:SetTarget(c59821121.pentg)
	e2:SetOperation(c59821121.penop)
	c:RegisterEffect(e2)
	--Set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(c59821121.pccon)
	e3:SetTarget(c59821121.pctg)
	e3:SetOperation(c59821121.pcop)
	c:RegisterEffect(e3)
	--immune spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c59821121.imcon)
	e4:SetValue(c59821121.efilter)
	c:RegisterEffect(e4)
	--return to deck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c59821121.descon)
	e5:SetTarget(c59821121.destg)
	e5:SetOperation(c59821121.desop)
	c:RegisterEffect(e5)
	--to pzone
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c59821121.con)
	e6:SetOperation(c59821121.op)
	c:RegisterEffect(e6)
	--draw&damage
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e7:SetCondition(c59821121.damcon)
	e7:SetCost(c59821121.damcost)
	e7:SetTarget(c59821121.damtg)
	e7:SetOperation(c59821121.damop)
	c:RegisterEffect(e7)
	--attribute
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_ADD_ATTRIBUTE)
	e8:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e8)
	--attribute2
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_ADD_ATTRIBUTE)
	e9:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e9)
	--attribute3
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_ADD_ATTRIBUTE)
	e10:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e10)
	--attribute4
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_ADD_ATTRIBUTE)
	e11:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e11)
	--attribute5
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EFFECT_ADD_ATTRIBUTE)
	e12:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e12)
end
function c59821121.penfilter4(c)
    return c:IsSetCard(0xa1a2) and not c:IsCode(59821039) and not c:IsCode(59821040) and not c:IsCode(59821041) and not c:IsCode(59821042) and not c:IsCode(59821043) and not c:IsCode(59821044) and not c:IsCode(59821045) and not c:IsCode(59821046) and not c:IsCode(59821048) and not c:IsCode(59821049) and not c:IsCode(59821085) and not c:IsCode(59821091) and not c:IsCode(59821092)
end
function c59821121.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821121.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821121.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821121.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821121.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821121.pcfil(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c59821121.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c59821121.pcfil,1,nil,tp)
end
function c59821121.pcfilter(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and not c:IsCode(59821121) and not c:IsForbidden()
end
function c59821121.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) and Duel.IsExistingMatchingCard(c59821121.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c59821121.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821121.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821121.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c59821121.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821121.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c59821121.destrfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c59821121.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821121.destrfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c59821121.destrfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c59821121.thfilter1(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c59821121.thfilter2(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c59821121.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821121.destrfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>=1 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
	local hg1=Duel.GetMatchingGroup(c59821121.thfilter1,tp,LOCATION_DECK,0,nil)
	if ct>=2 and hg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(59821121,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg1=hg1:Select(tp,1,1,nil)
		Duel.SendtoHand(shg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg1)
	end
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if ct>=3 and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(59821121,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local srg=rg:Select(tp,1,1,nil)
		Duel.Remove(srg,POS_FACEUP,REASON_EFFECT)
	end
	local hg2=Duel.GetMatchingGroup(c59821121.thfilter2,tp,LOCATION_DECK,0,nil)
	if ct==4 and hg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(59821121,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg2=hg2:Select(tp,1,1,nil)
		Duel.SendtoHand(shg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg2)
	end
end
function c59821121.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821121.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821121.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821121.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821121.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821121.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c59821121.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821121.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c59821121.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c59821121.damop(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dc)
	if dc:IsSetCard(0x95) and dc:IsType(TYPE_QUICKPLAY) then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
