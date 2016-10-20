--Elazul
function c59821037.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821037.splimit)
	e2:SetCondition(c59821037.splimcon)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c59821037.tg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59821037,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c59821037.drcon)
	e4:SetTarget(c59821037.drtg)
	e4:SetOperation(c59821037.drop)
	c:RegisterEffect(e4)
	--instant Xyz Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(59821037,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,59821037)
	e5:SetCost(c59821037.xyzcost)
	e5:SetTarget(c59821037.xyztg)
	e5:SetOperation(c59821037.xyzop)
	c:RegisterEffect(e5)
	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821037,2))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,59821037)
	e6:SetTarget(c59821037.eqtg)
	e6:SetOperation(c59821037.eqop)
	c:RegisterEffect(e6)
	--equip atkup
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(300)
	c:RegisterEffect(e7)
	--draw2
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(59821037,3))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLED)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(c59821037.drcon2)
	e8:SetTarget(c59821037.drtg2)
	e8:SetOperation(c59821037.drop2)
	c:RegisterEffect(e8)
end
function c59821037.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821037.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821037.tg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821037.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821037.drfilter(c)
	return c:IsSetCard(0xa1a2) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c59821037.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c59821037.drfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c59821037.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821037.drfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,2,2,nil)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	if sg:IsExists(Card.IsLocation,2,nil,LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c59821037.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c59821037.xyzfilter1(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xa1a2) and c:GetRank()==4
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c59821037.xyzfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa1a2) and c:GetLevel()==4
end
function c59821037.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c59821037.xyzfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c59821037.xyzfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c59821037.xyzfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c59821037.xyzfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c59821037.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	sg:RemoveCard(tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then 
			Duel.Overlay(tc,sg)
		end
	end
end
function c59821037.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821037.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c59821037.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c59821037.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c59821037.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c59821037.eqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c59821037.eqlimit)
	c:RegisterEffect(e1)
end
function c59821037.eqlimit(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821037.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget():IsRelateToBattle()
end
function c59821037.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c59821037.drop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
