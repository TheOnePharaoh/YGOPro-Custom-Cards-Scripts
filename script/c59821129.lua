--The Idol Master of Dancing Maiden Korisu Kokone
function c59821129.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,3,c59821129.ovfilter,aux.Stringid(59821129,0),3,c59821129.xyzop)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk and def calculation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c59821129.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c59821129.defval)
	c:RegisterEffect(e2)
	--attach
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(59821129,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c59821129.mattg)
	e3:SetOperation(c59821129.matop)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c59821129.tg)
	e4:SetValue(300)
	c:RegisterEffect(e4)
	--immune spell
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c59821129.imcon)
	e5:SetValue(c59821129.efilter)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821129,2))
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e6:SetCondition(c59821129.descon)
	e6:SetCost(c59821129.descost)
	e6:SetTarget(c59821129.destg)
	e6:SetOperation(c59821129.desop)
	c:RegisterEffect(e6)
	--to pzone
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c59821129.con)
	e7:SetOperation(c59821129.op)
	c:RegisterEffect(e7)
	--place pcard
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(59821129,3))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c59821129.pencon)
	e8:SetTarget(c59821129.pentg)
	e8:SetOperation(c59821129.penop)
	c:RegisterEffect(e8)
end
function c59821129.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and not c:IsCode(59821129)
end
function c59821129.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,59821129)==0 end
  Duel.RegisterFlagEffect(tp,59821129,RESET_PHASE+PHASE_END,0,1)
end
function c59821129.adfil(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER)
end
function c59821129.atkval(e,c)
	return c:GetOverlayGroup():Filter(c59821129.adfil,nil):Filter(Card.IsAttackAbove,nil,1):GetSum(Card.GetAttack)
end
function c59821129.defval(e,c)
	return c:GetOverlayGroup():Filter(c59821129.adfil,nil):Filter(Card.IsDefenseAbove,nil,1):GetSum(Card.GetDefense)
end
function c59821129.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c59821129.mfilter(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER)
end
function c59821129.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c59821129.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c59821129.mfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c59821129.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectTarget(tp,c59821129.mfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
function c59821129.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,tc,e)
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end
function c59821129.tg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821129.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c59821129.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821129.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821129.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c59821129.desfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c59821129.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821129.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c59821129.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*200)
end
function c59821129.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821129.desfilter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if Duel.Damage(1-tp,ct*200,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c59821129.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821129.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821129.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821129.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821129.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821129.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c59821129.penfilter4(c)
    return c:IsSetCard(0xa1a2) and not c:IsCode(59821039) and not c:IsCode(59821040) and not c:IsCode(59821041) and not c:IsCode(59821042) and not c:IsCode(59821043) and not c:IsCode(59821044) and not c:IsCode(59821045) and not c:IsCode(59821046) and not c:IsCode(59821048) and not c:IsCode(59821049) and not c:IsCode(59821085) and not c:IsCode(59821091) and not c:IsCode(59821092)
end
function c59821129.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821129.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821129.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821129.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821129.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
